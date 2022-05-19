#-*- coding: utf-8 -*-

# 导入包
import numpy as np
import matplotlib.cm as cm
import matplotlib.pyplot as plt
from PIL import Image

#读取图片，并转为数组
im = np.array(Image.open("C:/Users/t1327/Desktop/LeNet-5/data/MNIST/raw/train/926.jpg").convert('L'))
print(im)
#转为二进制
image_flat = []
for x in im.flat:
    y=np.binary_repr(x, width=16)#字符串形式
    image_flat.append(y)

#文件名
filename = f'C:/Users/t1327/Desktop/LeNet-5/image/4.coe'
# fid=open(filename,'w')
# fid.write("MEMORY_INITIALIZATION_RADIX=2;\n")
# fid.write("MEMORY_INITIALIZATION_VECTOR=")
np.savetxt(filename,image_flat,fmt='%s',newline=',')

# 打印数组
print(image_flat)
#print(im)
