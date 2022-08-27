
class Node 
    attr_accessor :left, :right, :value

    def initialize(value)
        @value = value
        @left = nil
        @right = nil
    end

end

class Tree
    attr_accessor :root, :array
    def initialize(array)
        @root = nil
        @array = array.uniq.sort
    end

    def build_tree(start, last)
        if start > last
            return nil
        end
        mid = (start + last) / 2
        node = Node.new(array[mid])
        if root == nil
            self.root = node
        end

        node.left = build_tree(start, mid - 1)
        node.right = build_tree(mid + 1, last)
        if node == root
            return root.value
        end
        return node
    end

    def insert(value)
        curr = root
        prev = root
        if array.include?(value)
            return nil
        end
        until curr == nil do
            if value > curr.value 
                prev = curr
                curr = curr.right
                if curr == nil
                    prev.right = Node.new(value)
                end
            
            else
                prev = curr
                curr = curr.left
                if curr == nil
                    prev.left = Node.new(value)
                end
            end
        end
        return prev.value
    end

    def delete(value)
        #case1: node has no child, just delete
        #case2: only one child, child replaces curr node spot
        #case3: node has 2 child, smallest node in the right subtree replaces node
        
        #find node
        prev = root
        curr = root
        direction = ''
        until curr.value == value do
            if value > curr.value
                prev = curr
                curr = curr.right
                direction = 'right'
            else
                prev = curr
                curr = curr.left
                direction = 'left'
            end
            if curr == nil
                return nil
            end
        end

        #determine case, need var to hold prev node and curr node
        if curr.right != nil && curr.left != nil
            tempPrev = curr
            replacement = curr
            replacement = replacement.right
            until replacement.left == nil do
                tempPrev = replacement
                replacement = replacement.left
            end
            if replacement.right != nil
            tempPrev.left = replacement.right
            else
                tempPrev.left = nil
            end
            replacement.left = curr.left
            replacement.right = curr.right

            if curr != root && direction == 'right'
                prev.right = replacement
            elsif curr != root && direction == 'left'
                prev.left = replacement
            else
                self.root = replacement
            end

        elsif (curr.right == nil && curr.left != nil) || (curr.left == nil && curr.right != nil)
            if direction == 'right'
                if curr.left != nil
                    prev.right = curr.left
                else
                    prev.right = curr.right
                end
            else
                if curr.left != nil
                    prev.left = curr.left
                else
                    prev.left = curr.right
                end
            end
        else
            if direction == 'right'
                prev.right = nil
            else
                prev.left = nil
            end
        end
        #delete and rearrange depending on case
        p prev.value
        if prev.left != nil 
            p prev.left.value
        else 
            p 'NO left'
        end
        if prev.right != nil
            p prev.right.value
        else
            p "NO RIGHT"
        end
    end

    def find(value)
        curr = root
        until curr.value == value do
            if value > curr.value
                curr = curr.right
            else
                curr = curr.left
            end
            if curr == nil
                return nil
            end
        end
        return curr
    end

    def level_order(curr = root, queue = [root], arr = [])
        return if curr == nil
        if queue.length > 0
            if block_given?
                yield(queue[0]) 
            else
                arr << queue[0].value
            end
            queue.shift()
        end
        if curr.left != nil
            queue.push(curr.left)
        end
        if curr.right != nil
            queue.push(curr.right)
        end
        level_order(curr.left, queue, arr)
        level_order(curr.right, queue, arr)


        return array if !block_given?
    end
    def rec(n)
        p array.object_id
        if n == 1
            return [1]
        end
        
        array = rec(n-1, array)
        array.push(n)
        return array
    end

    def inorder(curr = root, arr = [], &block)
        return arr if curr == nil
        arr = inorder(curr.left, arr, &block)
        if block_given?
            block.call(curr)
        else
            arr +=  [curr.value]
        end
        arr = inorder(curr.right, arr, &block)

        return arr if !block_given?
    end

    def preorder(curr = root, arr = [], &block)
        return arr if curr == nil
        if block_given?
            block.call(curr)
        else
            arr +=  [curr.value]
        end
        arr = preorder(curr.left, arr, &block)
        arr = preorder(curr.right, arr, &block)

        return arr if !block_given?
    end

    def postorder(curr = root, arr = [], &block)
        return arr if curr == nil
        arr = postorder(curr.left, arr, &block)
        arr = postorder(curr.right, arr, &block)
        if block_given?
            block.call(curr)
        else
            arr += [curr.value]
        end

        return arr if !block_given?
    end

    def height(node)
        return -1 if node == nil
        left = height(node.left)
        right = height(node.right)
        if left >= right
            return left + 1
        else
            return right + 1
        end
    end

    def depth(node)
        curr = root
        edges = 0
        until curr == node do
            if curr == nil || node == nil
                return -1
    
            elsif node.value > curr.value
                curr = curr.right
            else
                curr = curr.left
            end

            edges += 1
        end
        return edges
    end

    def balanced?()
        left = height(root.left) + 1
        right = height(root.right) + 1
        return (right-left).abs <= 1

    end

    def rebalance()
        self.array = inorder().uniq.sort
        p array
        self.root = nil
        build_tree(0, array.length-1)
    end
end
def block()
    if block_given?
        yield
    else
        puts 'noblock'
    end
end


#arr = [2, 3, 1, 4, 8, 67, 9, 23, 324, 6345]
#tree = Tree.new(arr)
#tree.build_tree(0, tree.array.length - 1)
#tree.insert(5)
#tree.insert(6)
#p tree.balanced?()
#p tree.rebalance()
#p tree.array
#p tree.balanced?()