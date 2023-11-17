#include <gtest/gtest.h>

#include "adder.h"

TEST(mytest, test_0)
{
  ASSERT_EQ(2, lib_a::adder(1, 1));
}

TEST(mytest, test_1)
{
  ASSERT_EQ(4, lib_a::adder(1, 3));
}