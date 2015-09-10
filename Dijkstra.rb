require 'debugger'

class Dijkstra
  # local class used to hold progress of the algorithm
  # For each node we hold the shortest path so far, and
  # previous node by which we got to this node on the shortest
  # path.
  Journey = Struct.new(:distance, :previous )
  
  def initialize
    # Represents the directed graph of nodes using a tree of hashes.  The
    # initial has provides for a given node a hash of verticies to neighbouring
    # nodes and their distance.
    # @network[:a] gives the hash of vertices from :a.
    # @network[:a][:b] returns 4 - the cost of the vertix from :a to :b
    # Because Ruby returns nil for a hash entry that does not exist, the table will return nil
    # if a lookup for a non-existant node is used.
    @graph = { :a => { :b => 4, :d => 1 },
               :b => { :a => 3, :c => 2 },
               :c => { :b => 4, :e => 5 },
               :d => { :a => 1, :e => 1 },
               :e => { :c => 3, :d => 1 } }
    
    # Both of these holds a Hash that maps the node to a Journey structure.  The
    # journey structure in turn holds the current shortest route distance to that
    # node, plus the previous node from which the path has come.
    @unvisited = {}
    @visited = {}           
  end
  
  # Returns the distance between two connected points
  def distance( origin, destination )
    return @graph[origin][destination]
  end
  
  # Determines the shorted path from start to finish using the graph in @graph
  # It uses the members @unvisited and @visited to hold the results of the algorithm
  def shortest_path( start, finish )
    current = nil

    # initialise the unvisited list by looping through each node in the network.
    # The starting node's distance is zero, all others are infinite.
    @graph.each_key do |node|
      if node == start
        @unvisited[node] = Journey.new( 0, nil )
        current = node
      else
        @unvisited[node] = Journey.new( 1000000, nil )
      end
    end
    
    #
    # Your code goes here
    #
            
    # move the last point to visited.
    @visited[ current ] = @unvisited.delete( current )
    
    return @visited[ current ].distance
  end
  
  # As we only store the predecessor, we use a head recursion starting with
  # the tail to build a string showing the shortest path.
  def output_route( node )
    if @visited[node].previous
      return output_route( @visited[node].previous ) + " -> " + node.to_s
    else
      return node.to_s
    end
  end  
end

d = Dijkstra.new
puts "shortest path from :a to :c is " + d.shortest_path( :a, :c ).to_s
puts "shortest path route is " + d.output_route( :c )
