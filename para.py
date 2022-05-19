from pyrsistent import b
import torch
from torch import float32, int16, nn
from net import MyLeNet5
import numpy as np


model = MyLeNet5()
model.load_state_dict(torch.load("save_model/best_model.pth"))

weight_num=model.state_dict()

weights_keys = model.state_dict().keys()
for key in weights_keys:
    # remove num_batches_tracked para(in bn)
    print(f'key:{key}')
    if "num_batches_tracked" in key:
        continue

    #转化为numpy数组
    weight_t = model.state_dict()[key].numpy()
    print(f'weight:\n{weight_t}\n\n')
    # print(f'weight tpye:{weight_t.shape}')
    #放大2^14倍，转化为整数
    weight_t = weight_t * 1024
    weight_int = np.array(weight_t, dtype=int)

    #转为二进制补码
    weight_flat = []
    for x in weight_int.flat:
        y=np.binary_repr(x, width=16)#字符串形式
        weight_flat.append(y)

    #文件名
    filename = f'C:/Users/t1327/Desktop/LeNet-5/weight/{key}1.coe'
    np.savetxt(filename,weight_flat,fmt='%s',delimiter =',')
    
    #print(f'shape is : {weight_int.shape}')
    print(f'weight:\n{weight_int}\n\n')


    weight_t = np.array((weight_int/1024), dtype=float)
    
    #print(f'weight:\n{weight_flat}\n\n')
    weight_num[key]=torch.from_numpy(weight_t)#转化后参数
    we = weight_num[key].numpy()
    print(f'weight:\n{we}\n\n')

    # read a kernel information
    # k = weight_t[0, :, :, :]

    # calculate mean, std, min, max
    # weight_mean = weight_t.mean()
    # weight_std = weight_t.std(ddof=1)
    # weight_min = weight_int.min()
    # weight_max = weight_int.max()

    # print("mean is {}, std is {}, min is {}, max is {}\n\n".format(weight_mean,
    #                                                            weight_std,
    #                                                            weight_min,
    #                                                            weight_max))
model.load_state_dict(weight_num)

torch.save(model.state_dict(),'save_model/fpga_model1.pth')
# print(weight_num.items())
