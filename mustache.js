var renderTemplate = function(template, args){
  var output = template;
  for (key in args){
    var value = args[key];
    output = output.replace('{{'+key+'}}', value);
  };
  return output
}

console.log(renderTemplate('hello {{first_name}} {{last_name}}, howaya', {
  firstName: "fei",
  lastName: "wang"
}))
