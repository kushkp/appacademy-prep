class MyHashSet
  attr_accessor :store

  def initialize
    @store = {}
  end

  def insert(el)
    @store[el] = true
  end

  def include?(el)
    @store.has_key?(el)
  end

  def delete(el)
    @store.delete(el) ? true : false
  end

  def to_a
    @store.keys
  end

  def union(set2)
    newset = MyHashSet.new
    newset.store = store.merge(set2.store)
    newset
  end

  def intersect(set2)
    newset = MyHashSet.new
    @store.each do |key,value|
      if set2.include?(key)
        newset.insert(key)
      end
    end
    newset
  end

  def minus(set2)
    newset = MyHashSet.new
    @store.each do |key,value|
      if !set2.include?(key)
        newset.insert(key)
      end
    end
    newset
  end
end

atest = MyHashSet.new
btest = MyHashSet.new
atest.insert(1)
atest.insert(3)
atest.insert(5)
btest.insert(2)
btest.insert(3)
btest.insert(4)
p atest.minus(btest)
