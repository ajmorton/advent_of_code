import unittest
import day_1, day_2

if __name__ == "__main__":
    with open("input/2.txt") as file:
        print(day_2.run(file, False))

class Tests(unittest.TestCase):
    def test_1_1(self):
        with open("input/1.txt") as file:
            self.assertEqual(day_1.run(file), 436404)

    def test_1_2(self):
        with open("input/1.txt") as file:
            self.assertEqual(day_1.run(file, True), 274879808)

    def test_2_1(self):
        with open("input/2.txt") as file:
            self.assertEqual(day_2.run(file), 477)

    def test_2_2(self):
        with open("input/2.txt") as file:
            self.assertEqual(day_2.run(file, True), 686)
