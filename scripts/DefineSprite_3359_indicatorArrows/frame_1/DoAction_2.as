var scrollStep = 5;
arrowL.onPress = arrowL.onDragOver = scrollRight;
arrowL.onRelease = arrowL.onDragOut = stopScroll;
arrowR.onPress = arrowR.onDragOver = scrollLeft;
arrowR.onRelease = arrowR.onDragOut = stopScroll;
