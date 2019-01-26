import cv2
import numpy as np
from matplotlib import pyplot as plt
a = cv2.imread('ms.png')
b = cv2.cvtColor(a, cv2.COLOR_BGR2HSV)
c = cv2.inRange(b, np.array([0, 43, 46]), np.array([25, 255, 255]))
d = cv2.inRange(b, np.array([140, 43, 46]), np.array([180, 255, 255]))
dst = cv2.bitwise_or(c, d)
# a1 = cv2.imread('ms.png', 0)
# ret, dst2 = cv2.threshold(a1, 0, 255, cv2.THRESH_OTSU | cv2.THRESH_BINARY)
# c = cv2.bitwise_and(a, c)
# c = cv2.cvtColor(c, cv2.COLOR_BGR2RGB)
plt.imshow(dst, cmap='gray'), plt.show()
