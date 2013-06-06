module Trees
( --sumLeaves
) where

import Data.Tree
import Control.Applicative (Applicative(..), (<$>))
import Control.Monad
import Data.Traversable (Traversable(traverse))


-- | draw a tree: putStrLn $ drawTree tree21
-- debug trees

drawT tree = putStrLn $ drawTree tree
drawT' tree = putStrLn $ drawTree $ fmap show tree

tree0 = Node {rootLabel = "0", subForest = []}
tree1 = Node {rootLabel = "1", subForest = []}
tree1Int = Node {rootLabel = 1, subForest = []}
tree2 = Node {rootLabel = "2", subForest = []}
tree2Int = Node {rootLabel = 2, subForest = []}
tree3Int = Node {rootLabel = 3, subForest = []}
tree123Int = Node {rootLabel = 7, subForest = tree1Int:tree2Int:tree3Int:[]}

tree1_123_23Int = Node 9 (tree1Int:tree123Int:tree2Int:tree3Int:[])
tree5Int = Node 5 []
tree6Int = Node 6 []

tree1_123_56Int = Node 6 ((Node (1) []):tree123Int:tree5Int:tree6Int:[])
tree1_123_56_1_123_23Int = Node 6 ((Node (1) []):tree123Int:tree5Int:tree6Int:tree1_123_23Int:[])
tree21Int = Node 21 (tree2Int:tree1Int:[])


tree21 = Node {rootLabel = "21", subForest = tree2:tree1:[]}
tree321 = Node {rootLabel = "321", subForest = tree2:tree1:tree21:[]}
tree231 = Node {rootLabel = "231", subForest = tree2:tree21:tree1:[]}
tree321321 = Node{rootLabel = "321321",subForest = tree321:tree321:[]}
tree231231 = Node{rootLabel = "231231",subForest = tree231:tree231:[]}

--treeFunc = Node (*0) (*1):(*2):(*3):[]

root = Node {rootLabel = "root", subForest = tree0:tree1:tree2:tree321:tree21:tree0:[]}
-- end of debug trees


leaf :: (Eq a) => Tree a -> Bool
leaf = (\x -> if (subForest x == []) then True else False)


-- | (f tree) -> rootLabel                                                                         
fmapT :: (Tree t -> a) -> Tree t -> Tree a
fmapT f tree@(Node x ts) = Node (f tree) (map (fmapT f) ts)


newLabel l (Node _ ts) = l


newLabel' l (Node _ ts) = Node l ts


newLabel'' (Node l _) (Node _ ts) = Node l ts


mapF f (Node l ts@(x:xs)) = Node l (map f ts)
mapF _ (Node l []) = Node l []


scanlT :: (a -> a -> a) -> Tree a -> Tree a -> Tree a
scanlT f q tree@(Node _ forest) = 
	let 
		k = rootLabel $ zipWithT' f q tree 
 		l = zipWithT' f q tree
	in case forest of
		[]     -> Node k []
		(t:ts) -> Node k (scanlF f l (t:ts))


scanlF :: (a -> a -> a) -> Tree a -> [Tree a] -> [Tree a]
scanlF f q forest = case forest of
					[]   -> []
					t:[] -> (scanlT f q t) : []
					t:ts -> (scanlT f q t) : scanlF f (scanlT f q t) ts


-- | zip 2 trees into a new tree, where the rootLabel is the product f of the 2 root
-- | labels, coming from each tree
zipWithT :: (t -> t1 -> a) -> Tree t -> Tree t1 -> Tree a
zipWithT f (Node l1 qs) (Node l2 ts) = Node (f l1 l2) (zipWithF f qs ts)


-- zipWithF :: (t -> t1 -> a) -> Forest t -> Forest t1 -> Forest a
zipWithF f (q:qs) (t:ts) = zipWithT f q t : zipWithF f qs ts
zipWithF _ _ _ = []


-- | Cheaper version of zipWithT: children are not computed 
zipWithT' :: (t -> t1 -> a) -> Tree t -> Tree t1 -> Tree a
zipWithT' f (Node l1 _) (Node l2 _) = Node (f l1 l2) []



leaves tree = fmapT ((\x -> if x == True then 1 else 0) . leaf) tree

sum_leaves tree = foldr1 (+) $ flatten $ zipWithT (*) tree (leaves tree) 


shifT' :: a -> Tree a -> Tree a
shifT' q (Node _ []) = Node q []
shifT' q tree@(Node l (t:ts)) = Node q (shifT' l t : map (shifT' l) ts)
	
shifT :: Tree a -> Tree a
shifT tree = shifT' (rootLabel tree) tree


fromIntegerT :: Fractional a => Tree Integer -> Tree a
fromIntegerT (Node tl []) = Node (fromInteger tl) []
fromIntegerT (Node tl ts) = Node (fromInteger tl) (map fromIntegerT ts)


weightT :: (Eq a, Fractional a) => Tree Integer -> Tree a
weightT tree = zipWithT (/) (k $ f tree) (l $ f tree)
	where 
		f = fromIntegerT
		k = fmapT sum_leaves 
		l t = shifT $ fmapT sum_leaves t


-- | Compute angles, based on weights
-- | An angle is the arc, connecting the x axis and the center of a leaf node

anglesT :: (Num a, Fractional a) => Tree a -> Tree a 
anglesT tree@(Node l forest) = Node q (anglesF q forest)
						      where q = 0.5 * l

anglesF :: (Num a, Fractional a) => a -> [Tree a] -> [Tree a] 
anglesF q forest = case forest of
		[] 	   -> []
		(t:[]) -> [Node l []] 
			where l = 180 * ( q + 0.5 * rootLabel t )
		(t:ts) -> Node l (anglesF l (subForest t)): anglesF l ts
			where l = 180 * ( q + 0.5 * rootLabel t )


geoT :: Floating t => Tree t -> Tree t -> Tree (t, t, t)
geoT = zipWithT (\weight angle -> (weight, weight*sin(angle), weight*cos(angle))) 

foo = anglesT (fromIntegerT tree1_123_56Int)
bar = weightT tree1_123_56Int
--drawT' $ geoT foo bar

-- drawT' $ ltoT (rootLabel tree1_123_56Int) tree1_123_56Int

--drawT' $ Node (*2) [] <*> tree123Int -- applicative functor usage example
--drawT' $ tree123Int >>= (\x -> Node (x*x) []) -- monad use example
--drawT' $ fmap (\x -> if x == True then 1 else 0) $ fmapT leaf tree1_123_56Int

-- ### I finished, looking for a way to use traversable, from Data.Trees
-- drawT' $ traverse id (Just tree123Int)
-- which is identical to this:
-- drawT' $ tree123Int >>= (\x -> Node (Just x) [])



--drawT' $ fmapT sum_leaves tree1_123_56Int

-- I need a function, which takes a tree and draws a set of circles.
-- 100) a draw function takes a triple (x, y, radius))
-- each tree contains leafs and branches
-- 		(~= each node contains 0 or more sub-nodes)
-- both branches and trees are represented as circles: a branch is a circle,
-- 		(~= each node is a circle)
-- surrounded by other circles - leaves and sub-branches
--		(~= each node is surrounded by 0 or more sub-nodes)
-- The tree is being walked through:
-- 5) Compute the number of sub-objects on a tree and their weights:
-- 10) 	Aquire a tree, containing weight (radius) values
--  		node weight is based on the number o sub-nodes per node

-- 13) 	Aquire a tree, containing the number of members per node 				#DONE

-- 15) 	(?) Modify the tree data type to accomodate for weights (radii) 
--      and number of members
--		   (number of members may be aquired from weights (radii)) 				#DONE/Not needed 
--         																		##- achieved with fmap and multiple trees/zips 

-- 20)  Tree [radii] -> Tree [x,y]
-- 25)  map draw $ zipWith (Tree -> (x,y,radius)) Tree [x,y] Tree [radii]

-- I am here: take a root coords - sin, cos -> child, repeat
-- arc: 
