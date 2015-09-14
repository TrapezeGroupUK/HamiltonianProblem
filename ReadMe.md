# 1 The Challenge

I have chosen as our programming challenge a problem that is solvable within
two hours.  This problem is best solved by recursion.  To make it more interesting,
I want you all to implement this in a language that very few of you will know.

It's 2016, and the US presidential election is down to Hilary Clinton versus
Donald Trump.   The polls are neck-and-neck.  In order to move the polls in her
favour, Hilary Clinton has decided to do one last mad rush visiting all eastern
states within the USA.  Eastern states are Minnesota, Iowa, Missouri, Arkansas,
and Louisiana and all states to the east of them. This will be followed by an
equal dash across all western states if time permits.

In order to appeal to the liberal vote, she has decided to do the trip by bus
rather than flying, and not to visit any state more than once.  So we need to help
her find a route starting in Washington DC and visiting each state only once.  She
does not need to return to Washington in the found journey.

In computer science terms, we can represent the USA as a set of nodes representing
the states.  If two states share a border, then this is represented as an undirected
vertex between the nodes. A path that visits every node in the graph only once is
called a Hamiltonian graph.  The problem of finding the set of all Hamiltonian graphs
in an undirected graph is NP-complete.  The first person to solve this problem
mathematically was Euler for the bridges of Konigsberg.

Here is an example of graph with the Hamiltonian cycle drawn on it:

![Hamiltonian Graph](https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Hamiltonian_path.svg/220px-Hamiltonian_path.svg)

I will provide you with a representation of the directed graph of US mainland states.
I also provide a method to remove the western states.  This is the map I used to
generate the network:

![States of the USA](https://upload.wikimedia.org/wikipedia/commons/thumb/9/92/Map_of_USA_with_state_names_2.svg/712px-Map_of_USA_with_state_names_2.svg.png)

# 2 A very quick introduction to Ruby

Ruby is my favourite language and I believe it to be almost perfect.  It has certain
similarities with Python and Perl, but also has some key differences which make
it very attractive.  This introduction is not intended to explain the language in
all its subtle flavours, but purely focus on the key items needed to implement
the algorithm.

Ruby has become famous as the language in which the Web framework Ruby-on-Rails
is developed.  The advantage of Ruby and Rails is that programmers are much more
productive than in more conventional languages and frameworks.  This is the reason
why many startups initially use Ruby as their initial language.  Github, Twitter and Groupon
are three famous examples.  This text you are reading has been rendered using Ruby.
Ruby's big disadvantage is execution speed.  As it is
interpreted, it is much slower than C or C++.  Once scale becomes an issue, people
often end up re-writing their applications in other languages.  Speed is also the
reason why we are only tackling half the USA.  I found that trying to determine
a Hamiltonian path for the entire mainland USA simply took too long.

## 2.1 Ruby is truly object oriented and strongly typed

Unlike Java, C++ or JavaScript, Ruby is a pure object oriented language: everything
is an object.  Ruby is also strongly typed, but unlike Java or C++ it is not statically
typed.  Instead, the interpreter does dynamic type checking at runtime.

The key reason this is important is that variables are purely references to objects.
As such they do not have a type.  In Ruby you declare a variable by using it – this
is different from most other programming languages where you have to explicitly
declare that you intend to use a variable.  For example:

```
irb(main):001:0> 1.class
=> Fixnum
irb(main):002:0> a = 1
=> 1
irb(main):005:0> a.object_id
=> 3
irb(main):006:0> 1.object_id
=> 3
irb(main):007:0> a = "Now A is a string"
=> "Now A is a string"
```

This short example shows that 1 is an object.  If we assign that object to the
variable _a_, it simply stores a reference to the object 1.  We can then decide
to assign _a_ to point at a completely different object such as a string.

## 2.2 Syntax Rules

In Ruby the common practice is to put one statement on one line.  The new line
is a statement terminator (unlike in C++, Java or JavaScript where a ';' needs
to be used).  Comments start with the '#' and go till the end of the line.

## 2.3 Defining a Class

This shows how we might define a class:
```ruby
class Hamiltonian
  # Constructor
  def initialize( g )
    @graph = g
  end

  # set things up for the recursive search.
  def find_hamiltonian(start)
  end

  private

  # Find a hamiltonian cycle recursively.  Function returns true
  # if a cycle has been found

  def find\_hamiltonian\_recursively(current)
  end
end
```

This shows all the key points about class definitions in Ruby.  Methods are
defined within the class using the _def_ keyword.

In common with variables, class variables are defined simply by using them.
A class variable is identified by the use of a preceding @ sign.  So in our example
@graph is a class variable.  One interesting fact about class variables is that
if you access a class variable that has not yet been set, it returns the _nil_ object.

## 2.4 Loops

Compared to many other languages, Ruby's looping structure is fairly simple. You
specify the condition at the start or end of the block that must be valid for the
loop to continue.  You can use _break_ and _continue_ as in other languages:

Here is a somewhat contrived example of a loop:
```ruby
def power2(n)
  i = 0
  a = 1
  while i < n
    a = a*2
    i = i + 1
  end

  return a
end
```
Ruby has a trick or two up its sleeve that means that programmers make much less
use of loops than in other programming languages.

## 2.5 Symbols

Many languages have enumerated types.  Ruby has a similar concept: symbols. 
Symbols are user to represent a value in a concise way.  Symbols are identified
in the source code simply by prefixing the symbol name with a colon:
```ruby
:wdc
```
Unlike in Java or C++, symbols are not grouped into enumerated types but declared
globally.  Each symbol object only exists once in the Ruby system.

## 2.6 Hash Tables

Ruby has a super-class called collections to store multiple objects.  The two most
important examples of collections in the language are Arrays and Hashes.
Ruby programmers do with these two constructs what programmers in other languages
often end up doing by creating private classes.  For our challenge today, I will
use a Hash to hold the graph of how the states are connected.  The following
shows a simple hash that is used to map a person to their age (all names and
ages are fictitious):

```
irb(main):002:0> ages = { "Peter" => 20, "Jane" => 5, "James" => 16 }
=> {"Peter"=>20, "Jane"=>5, "James"=>16}
irb(main):003:0> ages["Peter"]
=> 20
irb(main):004:0> ages["Mary"]
=> nil
```

The Hash defines a mapping from a key to a value.  There are no constraints on
what either the class of the keys or the values.  If we try to call up the value
for a key that is not in the table we get the _nil_ value back.

Now we said above, that the value can be any object.  So our graph of states is
represented as follows:
```ruby
states = {
  :wa => [:or, :id],
  :or => [:wa, :id, :nv, :ca],
  :ca => Set.new( [:or, :nv, :az] ),
  :id => Set.new( [:wa, :or, :nv, :ut, :wy, :mt] ),
  :ut => Set.new( [:id, :nv, :az, :co, :wy] ),

  # More lines as above.
}
```


## 2.7 Arrays and Sets

Arrays, and by extension Sets, work very similar to most other languages including
Java and C:

    D:\RubyDevKit>irb
    irb(main):001:0> a = [0, 1, 5, 10]
    => [0, 1, 5, 10]
    irb(main):002:0> a[0]
    => 0
    irb(main):003:0> a[3]
    => 10
    irb(main):004:0> a[6]
    => nil
    irb(main):005:0> a.push( "Peter" )
    => [0, 1, 5, 10, "Peter"]
    irb(main):006:0> a.pop
    => "Peter"
    irb(main):007:0>

The main difference to Java and C is that the array elements can be of any type.
Secondly, accessing an element that does not exist does not generate an error,
but simply returns the nil object.

## 2.8 Iterators

I mentioned above, that in Ruby people write traditional loops much less often
that they do in more conventional languages.  Instead, Ruby has a powerful mechanism
built into the language to allow iterators to be defined in a neat way.  Here is
a contrived example of using a loop to add all the ages in the Hash.

```ruby
def combined\_age
  ages = { "Peter" =>20, "David" => 5, "James" => 16 }
  total_age = 0
  ages.each_value do |age|
    total_age += age
  end
end
```
Actually, Ruby has an inbuilt method for Hashes that would achieve the same in
one method call, but that was not the point.  One gotcha to be wary of is the
block between the _do_ and _end_ has its own lexical scope.  So if you assign
to a not yet defined variable in the block, it will no longer exist once the
block completes.

In the above, I used the hash iterator `each_value`.  There is also a corresponding
`each_key`.  If you need to retrieve both at the same time there is a `each_pair`.
This returns the key and value as parameters.  The Dijkstra example shows how it
can be used.  For arrays an iterator `each` exists.  

## 2.9 Final Tricks: Other methods on Hash, Set and Array that may be useful

There are a couple of other methods that you will probably find useful:

- `unvisited.include?( node )` returns true if the `@unvisited` holds the value node.
- `@unvisited.empty?` returns `true` if `@unvisited` contains no values.
- `@unvisited.delete( node )` removes the `node` from `@unvisited` and returns it.
- `@unvisited.push( node )` appends node to `@unvisited`
- `@unvisited.pop` removes the last element from the array and returns it

To output the solution, assuming it is stored in an array, you will need the following statement:
```ruby
puts "complete journey = #{ @journey.join ( " -> " ) }"
```

# 3 Suggested Algorithm

We need three variables to capture where we have got to:

- *Unvisited* the list of nodes yet to be visited
- *Journey* an array holding the sequence in which nodes are visited
- *Current* the current node from which we are searching for the solution

The algorithm needs to examine for the current node each of the neighbours and
check if it has not been visited.  If so, the algorithm should recursively visit
each neighbour.  If a visit yields a solution, we simply finish the algorithm.
Otherwise, we eventually return to our predecessor.

# 4 The Template

To make the challenge more manageable I have created a template in the repository.
I have also included an example of Dijkstra's algorithm to show you how I solved
a similar problem.

You can either pull the repository if you are familiar with Git.  Otherwise,
get Github to provide you with a Zip file.

# 5 Scoring criteria

Your task is to write the algorithm.  Please submit your solution by email.  I
will check the submitted solution.  I will award points on the following:

- Time of submission
- If I spot a mistake (even if it finds the correct solution), I may deduct points.
- I will also be giving points for sensible variable names and for good commenting.
- I will give additional points, if you have built some degree of testing into your solution.

There will be a first and second prize for completing the competition.
