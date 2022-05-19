import torch
from torch import device, nn
from net import MyLeNet5
from torch.optim import lr_scheduler
from torchvision import datasets, transforms
import os
import timeit

# 数据格式转换为tensor
data_transform = transforms.Compose([
    transforms.ToTensor()
])

# 加载测试数据集
test_dataset = datasets.MNIST(
    root='./data', train=False, transform=data_transform, download=True)
test_dataloader = torch.utils.data.DataLoader(
    dataset=test_dataset, batch_size=1, shuffle=True)

# GPU训练
# if torch.cuda.is_available():
#     mode = "cuda"
# else:
#     mode = "cpu"

# 调用net模型，将数据转到GPU
#mode = "cuda"
mode = "cpu"
model = MyLeNet5().to(mode)

model.load_state_dict(torch.load("save_model/best_model.pth"))

# 定义一个损失函数
loss_fn = nn.CrossEntropyLoss()

# 定义一个优化器
optimizer = torch.optim.SGD(model.parameters(), lr=1e-3, momentum=0.9)

# 学习率
lr_scheduler = lr_scheduler.StepLR(optimizer, step_size=10, gamma=0.1)

model.eval()
loss, current, n,time_ans = 0.0, 0.0, 0,0
with torch.no_grad():
    
    for batch, (x, y) in enumerate(test_dataloader):
        # 前向传播
        x, y = x.to(mode), y.to(mode)
        starttime = timeit.default_timer()
        output = model(x)
        cur_loss = loss_fn(output, y)

        #eval_loss = cur_loss.item() * y.size(0) + eval_loss
        _, pred = torch.max(output, axis=1)
        cur_acc = torch.sum(y == pred)/output.shape[0]
        loss += cur_loss.item()
        current += cur_acc.item()
        n += 1
        endtime = timeit.default_timer()-starttime
        time_ans+=endtime

    print("val_loss:"+str(loss/n))
    print("val_acc:"+str(current/n))
    print(f'count:{n}')
    print(f'time:{time_ans}')