//
//  ViewController.swift
//  Algorithms
//
//  Created by 国富集团赵 on 2024/3/6.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let items = [("递归", "recursion"),
                 ("回溯", "backtrack"),
                 ("分治", "partition"),
                 ("贪心", "greedy"),
                 ("枚举", "enumeration"),
                 ("动态规划", "dynamicProgramming")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        self.tableView.rowHeight = 60
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView .dequeueReusableCell(withIdentifier: "UITableViewCell")
        cell?.textLabel?.text = item.0
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView .deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        let str = item.1
        let selector = NSSelectorFromString(str)
        if self.responds(to: selector) {
            self.perform(selector)
        }
    }
    
}

extension ViewController {
    
    // 递归（Recursion）：递归是一种通过调用自身来解决问题的方法。递归可以简化问题的表达，但需要小心处理递归的边界条件，避免无限递归导致栈溢出。
    @objc func recursion() {
     
        let result = self.factorial(5)
        print(result)
    }
    
    func factorial(_ n: Int) -> Int {
        if n == 0 {
            return 1
        } else {
            return n * factorial(n - 1)
        }
    }

    // 回溯（Backtracking）：回溯是一种通过不断尝试不同的解决方案来解决问题的方法。当发现当前尝试不可行时，回溯算法会退回上一步并尝试其他可能的选择，直到找到解决方案或者确定无解。
    @objc func backtrack() {
                
        print(subsets([1, 2, 3])) // 输出 [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]
    }
    
    func subsets(_ nums: [Int]) -> [[Int]] {
        var result = [[Int]]()
        var path = [Int]()
        
        func backtrack(_ start: Int) {
            result.append(path)
            for i in start..<nums.count {
                path.append(nums[i])
                backtrack(i + 1)
                path.removeLast()
            }
        }
        
        backtrack(0)
        return result
    }

    // 分治（Divide and Conquer）：分治是一种将大问题分解成小问题，并独立地解决这些小问题，最后将结果合并的方法。它通常用于处理可以被分割成独立子问题的问题，例如归并排序、快速排序等。
    @objc func partition() {
        
        print(mergeSort([5, 2, 9, 1, 7])) // 输出 [1, 2, 5, 7, 9]

    }
    
    func mergeSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        
        let middleIndex = array.count / 2
        let leftArray = mergeSort(Array(array[0..<middleIndex]))
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]))
        
        return merge(leftArray, rightArray)
    }

    func merge(_ leftArray: [Int], _ rightArray: [Int]) -> [Int] {
        var mergedArray = [Int]()
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < leftArray.count && rightIndex < rightArray.count {
            if leftArray[leftIndex] < rightArray[rightIndex] {
                mergedArray.append(leftArray[leftIndex])
                leftIndex += 1
            } else {
                mergedArray.append(rightArray[rightIndex])
                rightIndex += 1
            }
        }
        
        mergedArray += Array(leftArray[leftIndex...])
        mergedArray += Array(rightArray[rightIndex...])
        
        return mergedArray
    }

    // 贪心（Greedy）：贪心算法是一种通过每一步都选择当前最优解来构建最终解决方案的方法。贪心算法通常易于实现和理解，但不一定能够得到全局最优解，因为它对每一步的选择都不进行回溯。
    
    @objc func greedy() {
        
        print(coinChange([1, 2, 5], 11)) // 输出 3
    }
    
    func coinChange(_ coins: [Int], _ amount: Int) -> Int {
        var remainingAmount = amount
        var coinsCount = 0
        
        let sortedCoins = coins.sorted(by: >)
        
        for coin in sortedCoins {
            coinsCount += remainingAmount / coin
            remainingAmount %= coin
            if remainingAmount == 0 {
                break
            }
        }
        
        return remainingAmount == 0 ? coinsCount : -1
    }


    // 枚举（Enumeration）：枚举算法是一种通过遍历所有可能的解决方案来解决问题的方法。它适用于问题的解空间相对较小且可以枚举的情况。


    @objc func enumeration() {
        
        print(permutations([1, 2, 3])) // 输出 [[1, 2, 3], [1, 3, 2], [2, 1, 3], [2, 3, 1], [3, 1, 2], [3, 2, 1]]

    }
    
    func permutations(_ nums: [Int]) -> [[Int]] {
        if nums.isEmpty { return [[]] }
        var result = [[Int]]()
        
        for i in 0..<nums.count {
            var remainingNums = nums
            let currentNum = remainingNums.remove(at: i)
            let subPermutations = permutations(remainingNums)
            for var perm in subPermutations {
                perm.insert(currentNum, at: 0)
                result.append(perm)
            }
        }
        
        return result
    }

    // 动态规划（Dynamic Programming）：动态规划是一种通过将问题分解成重叠子问题，并保存子问题的解来优化求解过程的方法。动态规划通常用于求解具有最优子结构性质的问题，可以大幅减少重复计算，提高效率。

    @objc func dynamicProgramming() {
        
        print(fibonacci(6)) // 输出 8

    }
    
    func fibonacci(_ n: Int) -> Int {
        if n <= 1 {
            return n
        }
        
        var fib = [Int](repeating: 0, count: n + 1)
        fib[1] = 1
        
        for i in 2...n {
            fib[i] = fib[i - 1] + fib[i - 2]
        }
        
        return fib[n]
    }

}
