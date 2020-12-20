import unittest
import day_1,  day_2,  day_3,  day_4,  day_5,  day_6,  day_7,  day_8,  day_9,  day_10
import day_11, day_12, day_13, day_14, day_15, day_16, day_17, day_18, day_19, day_20

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

    def test_day_11(self):
        self.assertEqual(day_11.run(), (2093, 1862))

    def test_day_12(self):
        self.assertEqual(day_12.run(), (759, 45763))

    def test_day_13(self):
        self.assertEqual(day_13.run(), (370, 894954360381385))

    def test_day_14(self):
        self.assertEqual(day_14.run(), (14839536808842, 4215284199669))

    def test_day_15(self):
        self.assertEqual(day_15.run(), (289, 1505722))

    def test_day_16(self):
        self.assertEqual(day_16.run(), (20091, 2325343130651))

    def test_day_17(self):
        self.assertEqual(day_17.run(), (336, 2620))

    def test_day_18(self):
        self.assertEqual(day_18.run(), (24650385570008, 158183007916215))

    def test_day_19(self):
        self.assertEqual(day_19.run(), (203, 304))

    def test_day_20(self):
        self.assertEqual(day_20.run(), (32287787075651, False))
