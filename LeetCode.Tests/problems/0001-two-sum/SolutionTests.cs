using LeetCode.Problems.P0001;

namespace LeetCode.Tests.Problems.P0001;

public class SolutionTests
{
    [Fact(Skip = "Not implemented yet")]
    public void Example1()
    {
        int[] actual = new Solution().TwoSum(new[] { 2, 7, 11, 15 }, 9);

        Assert.Equal(new[] { 0, 1 }, actual);
    }

    [Fact(Skip = "Not implemented yet")]
    public void Example2()
    {
        int[] actual = new Solution().TwoSum(new[] { 3, 2, 4 }, 6);

        Assert.Equal(new[] { 1, 2 }, actual);
    }

    [Fact(Skip = "Not implemented yet")]
    public void Example3()
    {
        int[] actual = new Solution().TwoSum(new[] { 3, 3 }, 6);

        Assert.Equal(new[] { 0, 1 }, actual);
    }
}
