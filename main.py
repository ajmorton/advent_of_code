import unittest
import day_1, day_2, day_3

if __name__ == "__main__":
    with open("input/3.txt") as file:
        print(day_3.run(file))

class Tests(unittest.TestCase):
    def test_day_1(self):
        with open("input/1.txt") as file:
            self.assertEqual(day_1.run(file), (436404, 274879808))

    def test_day_2(self):
        with open("input/2.txt") as file:
            self.assertEqual(day_2.run(file), (477, 686))

    def test_day_3(self):
        with open("input/3.txt") as file:
            self.assertEqual(day_3.run(file), (270, 2122848000))
