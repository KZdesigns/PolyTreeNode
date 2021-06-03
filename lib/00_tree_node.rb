module Searchable
  
    def dfs(target = nil, &prc)
      raise "Need a proc or target" if [target, prc].none? #=> raise error if no target or prc are passed
      prc ||= Proc.new { |node| node.value == target } #=> if not prc was passed use
      #=> Proc.new { |node| node.value == target }
  
      return self if prc.call(self) #=> basecase if prc.call(self) is true then return self
  
      children.each do |child| #=> search through the children array 
        result = child.dfs(&prc) #=> inductive step
        return result unless result.nil? #=> return the result unless its nil
      end
  
      nil #=> return nil if do not return early!
    end
  
    def bfs(target = nil, &prc)
      raise "Need a proc or target" if [target, prc].none? #=> if tartget or prc is not passed in
      prc ||= Proc.new { |node| node.value == target } #=> if prc is not given then set prc to
        #=> Proc.new { |node| node.value == target } 
  
      nodes = [self] #=> starting the queue
      until nodes.empty? #=> once queue is stop the search
        node = nodes.shift #=> take the next element to process
  
        return node if prc.call(node) #=> processing the the element and return value if prc.call(node) == true
        nodes.concat(node.children) #=> shuving the children into the queue
      end
  
      nil #=> otherwise return nil
    end
  
    # def count
    #   1 + children.map(&:count).inject(:+)
    # end
  end
  
  class PolyTreeNode
    include Searchable #=> giving the polytree class access to the searchable
  
    attr_accessor :value #=> giving read and write access to @value
    attr_reader :parent #=> giving read access to @parent
  
    def initialize(value = nil)
      @value, @parent, @children = value, nil, [] #=> setting instance variables
    end
  
    def children #=> returns the the children of the node object
      @children.dup #=> #dup used so user cannot accident mess with the children array
    end
  
    def parent=(parent) #=> setting parent
      return if self.parent == parent #=> exit call if object parent == the parent passed in
  
      if self.parent #=> if there is parent value 
        self.parent._children.delete(self) #=> if object's parent children and delete current self from children array
      end

      @parent = parent #=> set the objects parent to the parent passed in
      self.parent._children << self unless self.parent.nil? #=> unless the objects parent is nil add the object to parents children
  
      self
    end
  
    def add_child(child) 
      child.parent = self #=> adding a child node
    end
  
    def remove_child(child) #=> removed child
      if child && !self.children.include?(child) #=> if node is not a child raise error message
        raise "Tried to remove node that isn't a child"
      end
  
      child.parent = nil 
    end
  
    protected
    # Protected method to give a node direct access to another node's
    # children. 
    def _children
      @children
    end
  end
  