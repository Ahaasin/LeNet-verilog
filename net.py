
import torch
from torch import nn

#
class MyLeNet5(nn.Module):
    #init net
    def __init__(self):
        super(MyLeNet5,self).__init__()

        self.c1 = nn.Conv2d(in_channels=1,out_channels=6,kernel_size=5)
        self.relu = nn.ReLU()
        self.s2 = nn.MaxPool2d(kernel_size=2,stride=2)
        self.c3 = nn.Conv2d(in_channels=6,out_channels=16,kernel_size=5)
        self.s4 = nn.MaxPool2d(kernel_size=2,stride=2)
        self.c5 = nn.Conv2d(in_channels=16,out_channels=120,kernel_size=4)

        self.flatten = nn.Flatten()
        self.f6 = nn.Linear(120,84)
        self.output = nn.Linear(84,10)


    def forward(self,x):
        x=self.relu(self.c1(x))
        x=self.s2(x)
        x=self.relu(self.c3(x))
        x=self.s4(x)
        x=self.c5(x)
        x=self.flatten(x)
        x=self.f6(x)
        x=self.output(x)
        return x


if __name__=="__main__":
    x=torch.rand([1,1,28,28])
    model=MyLeNet5()
    y=model(x)