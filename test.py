from importlib_metadata import requires
from sympy import false
import torch
from torch import nn 
from net import MyLeNet5
from torch.autograd import Variable
from torchvision.transforms import ToPILImage
from torchvision import datasets,transforms
import timeit
#数据格式转换为tensor
data_transform = transforms.Compose([
    transforms.ToTensor()
])

#加载训练数据集
train_dataset = datasets.MNIST(root='./data',train=True,transform=data_transform,download=True)
train_dataloader = torch.utils.data.DataLoader(dataset=train_dataset,batch_size=16,shuffle=True)
#加载测试数据集
test_dataset = datasets.MNIST(root='./data',train=False,transform=data_transform,download=True)
test_dataloader = torch.utils.data.DataLoader(dataset=test_dataset,batch_size=16,shuffle=True)

#GPU训练
if 0:
    mode="cuda"
else:
    mode="cpu"

#调用net模型，将数据转到GPU
model = MyLeNet5().to(mode)

model.load_state_dict(torch.load("save_model/fpga_model.txt"))

#获取结果
classes = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
]

#把tensor转化为图片，方便可视化
show = ToPILImage()

#进入验证
for i in range(5):
    x,y=test_dataset[i][0],test_dataset[i][1]
    #show(x).show()

    x=Variable(torch.unsqueeze(x,dim=0).float(),requires_grad=False).to(mode)
    starttime = timeit.default_timer()
    with torch.no_grad():
        pred = model(x)
        predicted,actual =classes[torch.argmax(pred[0])],classes[y]
        print(f'predicted: "{predicted}",actual:"{actual}"')

endtime = timeit.default_timer()-starttime
print(f'time:{endtime}')