import unittest
import day_1, day_2, day_3, day_4, day_5, day_6, day_7, day_8, day_9, day_10

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

    def test_day_6(self):
        self.assertEqual(day_6.run(), (6742, 3447))

    def test_day_7(self):
        self.assertEqual(day_7.run(), (224, 1488))

    def test_day_8(self):
        self.assertEqual(day_8.run(), (1818, 631))

    def test_day_9(self):
        self.assertEqual(day_9.run(), (20874512, 3012420))

    def test_day_10(self):
        self.assertEqual(day_10.run(), (2232, 173625106649344))
