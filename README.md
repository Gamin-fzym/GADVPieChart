# GADVPieChart
之前项目中需要用到饼状图来统计数据，我在Github上找到DVPieChart，因为它在样式上与我们UI的设计图差异不大。拿来改改样式，按需要传入数据就解决了问题。后来，需要统计的数据条数变得更多了，这时发现DVPieChart的view上展示不了太多标签，很多指示线还会交叉。后面在Github没重新找到更合适的饼状图，就只有自己提笔按照需求重写了一个状图。

<br/>绘制逻辑会也不复杂。
<br/>1、先画好饼状图（需要环状图的话放个白色的圆覆盖在中心就行了）；
<br/>2、再去view的四周计算文本的放置区域；
<br/>3、写个算法配对距离每个饼状图区域最合适的文本区域；
<br/>4、绘制饼状图各区域到最合适的文本区域的指示线和文本区域的文字；

<br/>示意图:
<br/>![1001.png](https://github.com/Gamin-fzym/GADVPieChart/blob/main/img-storage/1001.png)
<br/>![1002.png](https://github.com/Gamin-fzym/GADVPieChart/blob/main/img-storage/1002.png)
