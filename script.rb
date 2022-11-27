# class for a single node
class Node
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = left
    @right = right
  end
end

# class for the whole balanced binary tree
class Tree
  def initialize(array)
    @array = array
    @array.uniq!
    @array.sort!
    @root = build_tree(@array, 0, @array.length-1)
  end

  def build_tree(array, start_indx, end_indx)
    if start_indx > end_indx
      nil
    else
      mid = (start_indx + end_indx) / 2
      node = Node.new(array[mid])
      print node.data
      print ' '
      node.left = build_tree(array, start_indx, mid - 1)
      node.right = build_tree(array, mid + 1, end_indx)
      node
    end
  end

  def insert(value)
    new_node = Node.new(value)
    traverse_tree_to_insert(@root, new_node)
  end

  def traverse_tree_to_insert(cur_node, node_to_insert)
    return if node_to_insert.data == cur_node.data

    if node_to_insert.data > cur_node.data
      if cur_node.right.nil?
        cur_node.right = node_to_insert
      else
        traverse_tree_to_insert(cur_node.right, node_to_insert)
      end
    elsif node_to_insert.data < cur_node.data
      if cur_node.left.nil?
        cur_node.left = node_to_insert
      else
        traverse_tree_to_insert(cur_node.left, node_to_insert)
      end
    end
  end

  def delete(value)
    traverse_tree_to_delete(@root, @root, value, nil)
  end

  def traverse_tree_to_delete(prev_node, cur_node, value_to_delete, direction)
    if cur_node.data == value_to_delete
      delete_node(prev_node, cur_node, direction)
    elsif value_to_delete > cur_node.data
      traverse_tree_to_delete(cur_node, cur_node.right, value_to_delete, 'right')
    elsif value_to_delete < cur_node.data
      traverse_tree_to_delete(cur_node, cur_node.left, value_to_delete, 'left')
    end
  end

  def delete_node(prev_node, cur_node, direction)
    # if cur_node is a leaf node, simply delete it:
    if cur_node.left.nil? && cur_node.right.nil?
      prev_node.right = nil if direction == 'right'
      prev_node.left = nil if direction == 'left'
    # if cur_node has a child on the right, replace cur_node with the child:
    elsif cur_node.left.nil?
      prev_node.right = cur_node.right if direction == 'right'
      prev_node.left = cur_node.right if direction == 'left'
    # if cur_node has a child on the left, replace cur_node with the child:
    elsif cur_node.right.nil?
      prev_node.right = cur_node.left if direction == 'right'
      prev_node.left = cur_node.left if direction == 'left'
    # if cur_node has child on right and child on left, find the smallest child of the right child of cur_node:
    else
      find_node_to_swap(prev_node, cur_node, direction)
    end
  end

  def find_node_to_swap(prev_node, cur_node, direction)
    right_child = cur_node.right
    if right_child.left.nil?
      child_of_right_child = right_child.right
      case direction
      when 'right'
        prev_node.right.data = right_child.data
        prev_node.right.right = child_of_right_child
      when 'left'
        prev_node.left.data = right_child.data
        prev_node.left.right = child_of_right_child
      end
    else
      smallest_child = right_child.left
      before_smallest = right_child
      until smallest_child.left.nil?
        before_smallest = smallest_child
        smallest_child = smallest_child.left
      end
      child_of_smallest_child = smallest_child.right
      prev_node.right.data = smallest_child.data if direction == 'right'
      prev_node.left.data = smallest_child.data if direction == 'left'
      prev_node.data = smallest_child.data if direction.nil?
      before_smallest.left = child_of_smallest_child
    end
  end
end

arr = [1,2,3,4,5,6,7]
tree = Tree.new(arr)
tree.insert(12)
tree.delete(4)
p tree