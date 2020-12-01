import unittest
import day_1

if __name__ == "__main__":
    with open("input/1.txt") as file:
        print(day_1.run(file, True))

class Tests(unittest.TestCase):
    def test_1_1(self):
        with open("input/1.txt") as file:
            self.assertEqual(day_1.run(file), 436404)

    def test_1_2(self):
        with open("input/1.txt") as file:
            self.assertEqual(day_1.run(file, True), 274879808)
