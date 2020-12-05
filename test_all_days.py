import unittest
import day_1, day_2, day_3, day_4, day_5

# Run with `python -m unittest`

class Tests(unittest.TestCase):
    def test_day_1(self):
        self.assertEqual(day_1.run(), (436404, 274879808))

    def test_day_2(self):
        self.assertEqual(day_2.run(), (477, 686))

    def test_day_3(self):
        self.assertEqual(day_3.run(), (270, 2122848000))

    def test_day_4(self):
        self.assertEqual(day_4.run(), (247, 145))

    def test_day_5(self):
        self.assertEqual(day_5.run(), (888, 522))
