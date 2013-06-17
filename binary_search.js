var binarySearch = function(list1, item){
  var list = list1.sort();
  var startIndex = 0;
  var endIndex = list.length-1;
  var midIndex = Math.ceil(list.length/2);

  while(startIndex !== endIndex){

    midIndex = Math.ceil((endIndex+1)/2);
    var midVal = list[midIndex];
    if (item === midVal) {
      return midIndex;
    }else if (item < list[midIndex]){
      endIndex = midIndex;
      endIndex -= 1;
    }else if (item > list[midIndex]){
      startIndex = midIndex;
      startIndex += 1;
    };
  };
  return startIndex;
};

console.log(binarySearch([1,2,3,4,5], 5));
