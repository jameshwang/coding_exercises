var memory = [];

var Hash = function(){
  this.keys = [];
};

Hash.prototype.getIndex = function(key){
  var sum = 0
  for (var i = 0; i < key.length; i++){
    sum += key.charCodeAt(i);
  };
  return sum;
};

Hash.prototype.setValue = function(key, value){
  this.keys.push(key);
  var index = this.getIndex(key);
  memory[index] = value;
  return value
};

Hash.prototype.getValue = function(key){
  var index = this.getIndex(key);
  return memory[index];
};

Hash.prototype.showAll = function(){
  for (var i = 0; i < this.keys.length; i++){
    console.log(memory[h.getIndex(h.keys[i])]);
  };
};