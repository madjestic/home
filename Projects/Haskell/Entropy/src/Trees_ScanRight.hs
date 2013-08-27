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

tree1_123_56Int = Node 6 ((Node (-1) []):tree123Int:tree5Int:tree6Int:[])
tree1_123_56_1_123_23Int = Node 6 ((Node (-1) []):tree123Int:tree5Int:tree6Int:tree1_123_23Int:[])
tree21Int = Node 21 (tree2Int:tree1Int:[])


tree21 = Node {rootLabel = "21", subForest = tree2:tree1:[]}
tree321 = Node {rootLabel = "321", subForest = tree2:tree1:tree21:[]}
tree231 = Node {rootLabel = "231", subForest = tree2:tree21:tree1:[]}
tree321321=Node{rootLabel="321321",subForest = tree321:tree321:[]}
tree231231=Node{rootLabel="231231",subForest = tree231:tree231:[]}

root = Node {rootLabel = "root", subForest = tree0:tree1:tree2:tree321:tree21:tree0:[]}
-- end of debug trees


-- | Apply a function to the whole self.tree and write it into the rootLabel                                                                         
fmapT :: (Tree t -> a) -> Tree t -> Tree a
fmapT f tree@(Node x ts) = Node (f tree) (map (fmapT f) ts)


leaf :: (Eq a) => Tree a -> Bool
leaf = (\x -> if (subForest x == []) then True else False)


leaf' :: (Eq a) => Tree a -> Int
leaf' = (\x -> if (subForest x == []) then 1 else 0)



-- | Apply a function to the rootLabel and write it into the rootLabel
fmapF :: (Forest t -> a) -> Tree t -> Tree a
fmapF f (Node x ts) = Node (f ts) (map (fmapF f) ts)

-- ####### DEAD END
-- The following is an attempt to create a right-folding tree
-- which may be impossible

-- the furthest I went so far is to right-fold the subforest of a tree, but not all
-- subforests of the subforest.  I may get back to it with a stronger theoretic backing.
scanlF :: (Tree a -> Tree a -> Tree a) -> Tree a -> [Tree a] -> [Tree a]
scanlF f q forest = case forest of
                    []   -> []
                    t:ts -> scanlT f (f q t):scanlF f (f q t) ts 


scanlT :: (Tree a -> Tree a -> Tree a) -> Tree a -> Tree a
scanlT f tree = Node (rootLabel tree) (scanlF f tree (subForest tree))


scanrF :: (Tree a -> Tree a -> Tree a) -> Tree a -> [Tree a] -> [Tree a]
scanrF _ _ []     = []
scanrF _ _ [x]    = [x]
scanrF f q (x:xs) = f q x : qs
					 where qs@(q:_) = scanrF f (f q x) xs

-- | This function should do ~: rootLabel = sum forest rootLabels
scanrT :: (Tree a -> Tree a -> Tree a) -> Tree a -> Tree a
scanrT _ tree@(Node _ [])     = tree
scanrT f tree@(Node l (x:xs)) = scanrT f (Node (rootLabel(f tree x)) (scanrF f tree xs))


foo = (\q t -> Node ((rootLabel q) + (rootLabel t)) (subForest t))
-- ############################### END OF DEAD END


-- write a function, that accumulates a value, before passing it as an argument to the next
-- member of a set

-- | zip 2 trees into a new tree, where the rootLabel is the product f of the 2 root
-- | labels, coming from each tree
--zipTreesWith f (Node a ts) (Node b ks) = (Node (f a b) (zipWith (zipTreesWith f) ts ks))


boolToInt :: Bool -> Integer
boolToInt = (\x -> if x == True then 1 else 0)


-- | rootLabel becomes a list of subforest rootLabel values as [Int]
listLabelsF :: Tree [Char] -> Tree [Int]
listLabelsF = fmapF (map (read . rootLabel))


listBoolLeaves :: Tree [Char] -> Tree [Bool]
listBoolLeaves = fmapF (map (leaf))


--instance Traversable Tree where
--    traverse f (Node x ts) = Node <$> f x <*> traverse (traverse f) ts


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

members :: Tree t -> Tree Int
members = fmapF (length)

-- 15) 	(?) Modify the tree data type to accomodate for weights (radii) 
--      and number of members
--		   (number of members may be aquired from weights (radii)) 				#DONE/Not needed 
--         																		##- achieved with fmap and multiple trees/zips 

-- 20)  Tree [radii] -> Tree [x,y]
-- 25)  map draw $ zipWith (Tree -> (x,y,radius)) Tree [x,y] Tree [radii]
