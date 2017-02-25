function debounce(func, wait, immediate) {
	var timeout;
	return function() {
		var context = this, args = arguments;
		var later = function() {
			timeout = null;
			if (!immediate) func.apply(context, args);
		};
		var callNow = immediate && !timeout;
		clearTimeout(timeout);
		timeout = setTimeout(later, wait);
		if (callNow) func.apply(context, args);
	};
};


function fixHeader() {
  var header = $("#register-header");
  var icon = $('#register-side-menu-icon')
  var logo = $('.logo-container')
  var firstContainer = $('#first-container')

  if ($(this).scrollTop() > 400) {
    header.addClass("fix-to-top");
    firstContainer.addClass("header-offset");
    icon.stop(true).removeClass("hide")
    logo.removeClass("hide");
  } else {
    header.removeClass("fix-to-top");
    icon.addClass("hide");
    // add.addClass("fix-to-top");
    firstContainer.removeClass("header-offset");
  }

};

var myEfficientFn = debounce(function() {
	fixHeader()
}, 10);

window.addEventListener('scroll', myEfficientFn);
