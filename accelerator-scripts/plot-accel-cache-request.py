# plot address vs timestamp. To show variation of address range in trace with time

import matplotlib
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure, show
import numpy as npy
from numpy.random import rand

f=open('temp3','r')
count=0
lines=[]

#parsing begin
for line in f:
    count=count+1
    words=line.split()
    lines.append(words)
print (str(count) + "\n")
print ("num lines: " + str(len(lines)))
#parsing end

timestamp_plt = []
address_plt = []
resp_req_plt = []
# temp2:
# 1: msg ID
# 2: address
# 3: timestamp
for line in lines:
    #    timestamp=line[30]
    #print line[1] + " address: " + str(int(line[3],0)) + " timestamp: " + str(int(line[5],0))
    address = int(line[9],0)
    timestamp = int(line[0],0)
    resp_req = line[6]
    timestamp_plt.append(timestamp)
    address_plt.append(address)
    if resp_req == "translating":
        resp_req_plt.append(1)
    elif resp_req == "issued":
        resp_req_plt.append(2)
    elif resp_req == "waiting_from_cache":
        resp_req_plt.append(3)
    elif resp_req == "retry":
        resp_req_plt.append(4)
    elif resp_req == "received":
        resp_req_plt.append(5)
    elif resp_req == "returned":
        resp_req_plt.append(6)
f.close()
print ("max address: ", hex(max(address_plt)))
norm = plt.Normalize(1, 6)


if 1:
    c,s=npy.ones( (2,len(address_plt)) )
    t=npy.array(resp_req_plt)
    #x, y, c, s = rand(4, 100)
    print (c)
    def onpick3(event):
        ind = event.ind
        #print 'onpick3 scatter:', ind, npy.take(x, ind), npy.take(y, ind)
        print ('onpick3 scatter:', ind, 'timestamp: ', npy.take(timestamp_plt, ind)[0], 'address: ', hex(npy.take(address_plt, ind)[0]))
    fig = figure()
    ax1 = fig.add_subplot(111)
    col = ax1.scatter(timestamp_plt, address_plt, 20*s, c=t, cmap=matplotlib.colors.ListedColormap(['red', 'blue','green', 'orange', 'cyan', 'black']), picker=True)
    #cax = ax1.imshow(resp_req_plt, interpolation='nearest', cmap=matplotlib.cm.coolwarm)
    #col = ax1.scatter(timestamp_plt, address_plt, 20*s, c, picker=True)
    fig.canvas.mpl_connect('pick_event', onpick3)


# plot ideal address trace
# identify peaks in the address trace
# count=0
# for addr in address_plt:
#    count=count+1
# add points to timestamp_plt2 and address_plt2
# scatter plot
#legend1 = ax1.legend(col.legend_elements(), loc = "lower left", title="Classes#")
#ax1.legend()
plt.colorbar(col)
plt.show()
