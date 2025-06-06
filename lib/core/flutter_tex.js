"use strict";
var isWeb = false;
var teXView;
// Define MutationObserver before it's used
var observer = new MutationObserver(function(mutations) {
    attachLoadListenersToAllImages();
});

function initTeXView(rawData) {
    teXView = document.getElementById('TeXView');
    teXView.innerHTML = '';
    teXView.appendChild(createTeXView(rawData));
    attachLoadListenersToAllImages();
    renderTeXView(renderCompleted);
}


function initWebTeXView(viewId, rawData) {
    isWeb = true
    var initiated = false;
    var iframeElement = document.getElementById(viewId);
    if (iframeElement) {
        var iframeContent = iframeElement.contentWindow;
        if (iframeContent) {
            teXView = iframeContent.document.getElementById('TeXView');
            if (teXView) {
                teXView.innerHTML = '';
                teXView.appendChild(createTeXView(JSON.parse(rawData)));
                attachLoadListenersToAllImages(iframeContent.document);
                var renderTeXViewFn = iframeContent.renderTeXView;
                if (renderTeXViewFn) {
                    renderTeXViewFn(renderCompleted);
                    initiated = true;
                }
            }
        }
    }

    if (!initiated) setTimeout(function () {
        initWebTeXView(viewId, rawData)
    }, 100);
}


function createTeXView(rootData) {
    var meta = rootData['meta'];
    var data = rootData['data'];
    var id = meta['id']
    var classList = meta['classList'];
    var element = document.createElement(meta['tag']);
    element.classList.add(classList);
    element.setAttribute('style', rootData['style']);
    element.setAttribute('id', id)
    switch (meta['node']) {
        case 'leaf': {
            if (meta['tag'] === 'img') {
                if (classList === 'tex-view-asset-image') {
                    element.setAttribute('src', getAssetsUri() + data);
                    element.addEventListener("load", renderCompleted);
                    element.setAttribute('data-has-load-listener', 'true');
                } else {
                    element.setAttribute('src', data);
                    element.addEventListener("load", renderCompleted);
                    element.setAttribute('data-has-load-listener', 'true');
                }
            } else {
                element.innerHTML = data;
            }
        }
            break;
        case 'internal_child': {
            element.appendChild(createTeXView(data))
            if (classList === 'tex-view-ink-well') clickManager(element, id, rootData['rippleEffect']);
        }
            break;
        case 'root':
            rootData['fonts'].forEach(function (font) {
                registerFont(font['font_family'], font['src'])
            })
            element.appendChild(createTeXView(data));
            
            // Add wheel event listener to the root element
            element.addEventListener('wheel', function(e) {
                e.preventDefault();
                onWheelCallback(e.deltaY);
            });
            
            // Start observing the element for changes
            observer.observe(element, { 
                childList: true,
                subtree: true,
                attributes: true,
                characterData: true
            });
            
            break;
        default: {
            if (classList === 'tex-view-group') {
                createTeXViewGroup(element, rootData);
            } else {
                data.forEach(function (childViewData) {
                    element.appendChild(createTeXView(childViewData))
                });
            }
        }
    }
    return element;
}

function createTeXViewGroup(element, rootData) {

    var normalStyle = rootData['normalItemStyle'];
    var selectedStyle = rootData['selectedItemStyle'];
    var single = rootData['single'];
    var lastSelected;
    var selectedIds = [];


    rootData['data'].forEach(function (data) {
        data['style'] = normalStyle;
        var item = createTeXView(data);
        var id = data['meta']['id'];
        item.setAttribute('id', id);

        clickManager(item, id, rootData['rippleEffect'], function (clickedId) {
            if (clickedId === id) {
                if (single) {
                    if (lastSelected != null) lastSelected.setAttribute('style', normalStyle);
                    item.setAttribute('style', selectedStyle);
                    lastSelected = item;
                    onTapCallback(clickedId);
                } else {
                    if (arrayContains(selectedIds, clickedId)) {
                        document.getElementById(clickedId).setAttribute('style', normalStyle);
                        selectedIds.splice(selectedIds.indexOf(clickedId), 1)
                    } else {
                        document.getElementById(clickedId).setAttribute('style', selectedStyle);
                        selectedIds.push(clickedId);
                    }
                    onTapCallback(JSON.stringify(selectedIds));
                }
            }
            renderCompleted();
        })
        element.appendChild(item);
    });
}

function arrayContains(array, obj) {
    var i = array.length;
    while (i--) {
        if (array[i] === obj) {
            return true;
        }
    }
    return false;
}

function renderCompleted() {
    var height = getTeXViewHeight(teXView);
    if (isWeb) {
        TeXViewRenderedCallback(height);
    } else {
        TeXViewRenderedCallback.postMessage(height);
    }
}

function clickManager(element, id, rippleEffect, callback) {
    element.addEventListener('click', function (e) {
        if (callback != null) {
            callback(id);
        } else {
            onTapCallback(id);
        }

        if (rippleEffect) {
            var ripple = document.createElement('div');
            this.appendChild(ripple);
            var d = Math.max(this.clientWidth, this.clientHeight);
            ripple.style.width = ripple.style.height = d + 'px';
            var rect = this.getBoundingClientRect();
            ripple.style.left = e.clientX - rect.left - d / 2 + 'px';
            ripple.style.top = e.clientY - rect.top - d / 2 + 'px';
            ripple.classList.add('ripple');
        }
    });
}


function onTapCallback(message) {
    if (isWeb) {
        OnTapCallback(message);
    } else {
        OnTapCallback.postMessage(message);
    }
}

function onWheelCallback(message) {
    if (isWeb) {
        OnWheelCallback(message);
    }
}

function getTeXViewHeight(view) {
    var height = view.offsetHeight,
        style = window.getComputedStyle(view)
    return ['top', 'bottom']
        .map(function (side) {
            return parseInt(style["margin-" + side]);
        })
        .reduce(function (total, side) {
            return total + side;
        }, height)
}


function registerFont(fontFamily, src) {
    var registerFont =
        ' @font-face {                               \n' +
        '   font-family: ' + fontFamily + ';         \n' +
        '   src: url(' + getAssetsUri() + src + ');  \n' +
        ' }';
    appendStyle(registerFont);
}

function getAssetsUri() {
    var currentUrl = location.protocol + '//' + location.host;
    var uri;
    if (isWeb) {
        uri = currentUrl + '/assets/';
    } else {
        uri = currentUrl + '/';
    }
    return uri
}

function appendStyle(content) {
    var style = document.createElement('STYLE');
    style.type = 'text/css';
    style.appendChild(document.createTextNode(content));
    document.head.appendChild(style);
}

// Function to attach load event listeners to all img elements
function attachLoadListenersToAllImages(doc) {
    var document = doc || window.document;
    
    // If teXView isn't available yet, just return
    if (!teXView) return;
    
    // Get all img elements, including those that may have been added through innerHTML
    var imgElements = teXView.querySelectorAll('img');
    
    for (var i = 0; i < imgElements.length; i++) {
        // Only add event listener if it hasn't been added before
        var hasListener = imgElements[i].getAttribute('data-has-load-listener') === 'true';
        if (!hasListener) {
            imgElements[i].addEventListener('load', renderCompleted);
            imgElements[i].setAttribute('data-has-load-listener', 'true');
            
            // If the image is already loaded, manually trigger renderCompleted
            if (imgElements[i].complete && imgElements[i].naturalHeight !== 0) {
                renderCompleted();
            }
        }
    }
}
