var util = {};
util.bind = function(fn, context, var_args) {
  if (arguments.length > 2) {
	var boundArgs = Array.prototype.slice.call(arguments, 2);
	return function() {
	  var newArgs = Array.prototype.slice.call(arguments);
	  Array.prototype.unshift.apply(newArgs, boundArgs);
	  return fn.apply(context, newArgs);
	};

  } else {
	return function() {
	  return fn.apply(context, arguments);
	};
  }
};