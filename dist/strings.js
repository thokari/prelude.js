// Generated by LiveScript 1.2.0
'use strict';
var curry, arrays, repeat, reverse, capitalize, decapitalize, capitalizeSentence, camelize, dasherize, out$ = typeof exports != 'undefined' && exports || this;
curry = require('./funcs').curry;
arrays = require('./arrays');
out$.repeat = repeat = curry(function(n, str){
  var result, i$;
  result = '';
  for (i$ = 0; i$ < n; ++i$) {
    result += str;
  }
  return result;
});
out$.reverse = reverse = function(str){
  return arrays.reverse(str).join('');
};
out$.capitalize = capitalize = function(str){
  return str.charAt(0).toUpperCase() + str.slice(1);
};
out$.decapitalize = decapitalize = function(str){
  return str.charAt(0).toLowerCase() + str.slice(1);
};
out$.capitalizeSentence = capitalizeSentence = function(str){
  return str.replace(/(^.|\s.)/g, function(arg$, c){
    return (c != null ? c : '').toUpperCase();
  });
};
out$.camelize = camelize = function(str){
  return str.replace(/[-_]+(.)?/g, function(arg$, c){
    return (c != null ? c : '').toUpperCase();
  });
};
out$.dasherize = dasherize = function(str){
  return str.replace(/([^-A-Z])([A-Z]+)/g, function(arg$, lower, upper){
    upper = upper.length > 1
      ? upper
      : upper.toLowerCase();
    return lower + '-' + upper;
  }).replace(/^([A-Z]+)/, function(arg$, upper){
    if (upper.length > 1) {
      return upper + '-';
    } else {
      return upper.toLowerCase();
    }
  });
};