import cv2
import numpy as np

# These should be pretty much same distance from the subject
img7_path = "Z:/plenoptima/plenoptima_ws2_1/WS2_Body/WS2_Bodies_220613_ID10_VS01/pngs_test/7/00000_DepthMap16bit.png"
img31_path = "Z:/plenoptima/plenoptima_ws2_1/WS2_Body/WS2_Bodies_220613_ID10_VS01/pngs_test/31/00000_DepthMap16bit.png"

img7 = cv2.imread(img7_path, cv2.IMREAD_GRAYSCALE)
img7 = np.double(img7)
cv2.imshow('depth 7', img7)

img31 = cv2.imread(img31_path, cv2.IMREAD_GRAYSCALE)
cv2.imshow('depth 31', np.double(img31))

print(np.max(img7))
print(np.max(img31))

cv2.waitKey(0) 
cv2.destroyAllWindows() 