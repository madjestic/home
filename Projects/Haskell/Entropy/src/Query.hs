 -----------------------------------------------------------------------------
--
-- Module      :  Query
-- Copyright   :
-- License     :  AllRightsReserved
--
-- Maintainer  :  madjestic13@gmail.com
-- Stability   :  unstable
-- Portability :
--
-- |
--
-----------------------------------------------------------------------------

module Query
(convRow
,convRow'
,query'
,query_visits
,node_radius
,p_nodes_angles
,p_nodes_positions
) where

import Graphics.Gloss
import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC
import Data.List

--draw_circles :: IO()
--draw_circles = display (InWindow "My Window" (200, 200) (10, 10)) white (Circle 80)

convRow :: [SqlValue] -> String
convRow [sqlId, sqlDesc] =
    show intid ++ ": " ++ desc
    where intid = (fromSql sqlId):: Integer
          desc = case fromSql sqlDesc of
                   Just x -> x
                   Nothing -> "NULL"
convRow x = fail $ "Unexpected result: " ++ show x

convRow' :: [SqlValue] -> String
convRow' [sqlId, sqlDesc_Url, sqlDesc_From_Visit] =
    show id ++ ": " ++ url ++ ": " ++ from_visit
    where id = (fromSql sqlId):: Integer
          url        = case fromSql sqlDesc_Url of
                     Just x -> x
                     Nothing -> "NULL"
          from_visit = case fromSql sqlDesc_From_Visit of
                     Just x -> x
                     Nothing -> "NULL"
convRow' x = fail $ "Unexpected result: " ++ show x


{- | Define a function that takes an integer representing the maximum
tmt <- prepare conn "SELECT * fromOAd value to look up.  Will fetch all matching rows from the test database
and print them to the screen in a friendly format. -}

query' :: Int -> IO ()
query' maxId =
	do -- Run the query and store the results in r
	   conn <- connectSqlite3 "History"
	   r <- quickQuery' conn
			"SELECT id, url from urls where id <= ? ORDER BY id, url"
			[toSql maxId]

	   -- Convert each row into a String
	   let stringRows = map convRow r
						
	   -- Print the rows out
	   mapM_ putStrLn stringRows

	   -- And disconnect from the database
	   disconnect conn

query_visits :: Int -> IO ()
query_visits maxId =
    do -- Run the visists query and store the results in t
        conn <- connectSqlite3 "History"
        r <- quickQuery' conn
            "SELECT id, url, from_visit from visits where id <= ? ORDER BY from_visit"
            [toSql maxId]

	   -- Convert each row into a String
        let stringRows = map convRow' r
						
	   -- Print the rows out
        mapM_ putStrLn stringRows

	   -- And disconnect from the database
        disconnect conn


-- # Outline of the algoithm, meant to solve the problem of composing
-- a dependency tree.

-- The algorithm starts with a root node, and traces it's possible
-- children and/or parents.  It works either in both ways or in a
-- specified direction.

-- The parents are defined by 'from_visit' field of visits table.
-- The children are defined, by calling all values, with 'from_visit'
-- field value == current id.

-- # Visualisation: parent and children nodes are attached to a current node,
-- visualised as circles and lines.  It is, essentially 2 algorithms,
-- but can be encapsulated into a single function with an extra argument,
-- switching it between 2 states. A switch argumetn.

-- Here I will start with a variant with 2 functions:

-- draw_parent:: function visualises 1 or more circles, attached to a current
-- node. It takes 2 arguments: a list of parent nodes and a current node.


---- draw_parents :: [parents] -> current -> IO ()
---- draw_parents

---- draw_children::[children]-> current -> IO ()


-- EDIT: It takes 1 argument: a list of nodes (head:tail), where the head
-- is the current node and tail is the list of parent nodes.

---- draw_parents :: [nodes] -> IO ()
---- draw_parents (current:parents) =
----	current := draw_circle at (0,0, radius = 1)
----    parent  := draw_circle at (0-x, 0-y, radius = 1)
---- 			where:
----				x,y-?

--				x,y are centers of circles, located along the arc, which is a part
--				of the perimeter of a circle with the center at (0,0).
--				Let's create the a function, which computes the distance of a
--				current node to a parent node:

---- arc_length :: [nodes] -> radius
---- arc_length [nodes] = length [nodes] -- (here we assume the same r=1 for each parent)

-- draw_parent visualises parent nodes as series of circles, with radius r (r=1 by default),
-- whose centers are positioned along the arc in the lower hemisphere of the current node.
-- The radius of the arc is big enough to fit all the parent nodes with respective
-- grand-parent nodes, visualised in a similar fashion.  Therefore the radius of the
-- current node's arc is determined by escalating the properties if the deepest parent.
-- If such escalation makes fitting all the parents to the current node's arc radius impossible
-- (the nodes are too dense), then the current node's arc radius is increased, till all
-- parent nodes fit into such radius.  In the future radius of nodes may be scaled for a similar
-- purpose, though I'd prefer to avoid it at this stage.

-- Parent's radius is the radius of the group of its parents.  We start with such function.

---- node_radius :: [parents] -> Float
---- node_radius parents

--	take a parent node, take its radius, add that to next parent node radius, repeat, till
--	[parents] is exhausted.  The resulting value is the length of the arc.  Determin the
--	arc radius, readoning that the arc  length is 1/2 of the circle perimeter:
------					let length = l
------						     l = L/2 => L = 2*l
------								L = 2*Pi*r^2 => 2*l = 2*Pi*r^2
------					   (reduce common scalar 2*) => l = Pi*r^2
------									    => r^2 = l/Pi
------									    => r = sqrt(l/Pi)
------										  where l = arc_length

--[parent nodes radii] -> node_radius
node_radius :: [Float] -> Float
node_radius []   = 0
node_radius xs = sqrt (arc_length/pi)
                 where arc_length = foldl1 (+) xs


--[parent nodes radii] -> [parent nodes angles]
p_nodes_angles :: [Float] -> [Float]
p_nodes_angles xs = map (180/arc_length*) (scanl1 (+) xs) -- zipWith const [1..] xs produces
             	   where arc_length  = foldl1 (+) xs

--[parent nodes angles] -> radius -> [parent nodes (x,y) positions]
p_nodes_positions :: [Float] -> Float -> [(Float, Float)]
p_nodes_positions [] _ = []
p_nodes_positions (x:xs) r = (pos_x,pos_y) : p_nodes_positions xs r
                        where pos_x = r*cos (x)
                              pos_y = r*sin (x)

-- a list of indexes [1,2,3..]

--	Therefore, every parent node is
--	The deepest parent crriteria means that we have to get to the deepest parent as a
--	starting radius.  We need to get to the leaf.

-- We start with a simple function:  1 current node and a fixed number of parent nodes.
-- Consider a single generation first: radius = 1.




