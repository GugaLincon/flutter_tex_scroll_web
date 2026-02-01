// Enable strict mode for better error handling
"use strict";

// Retrieve TeX packages from MathJax if available
const tex_packages = (window.MathJax && window.MathJax.tex) ? window.MathJax.tex.packages : null;

// Function to initialize the TeXView
function initTeXView(context, flutterTeXData, isWeb, iframeId = "") {
    let container = isWeb
        ? context.document.getElementById('TeXView')
        : document.getElementById('TeXView');

    if (!container) return;

    container.innerHTML = '';

    const parsedData = (typeof flutterTeXData === 'string')
        ? JSON.parse(flutterTeXData)
        : flutterTeXData;

    const view = createTeXViewBuilder(parsedData, container, iframeId, isWeb);
    container.appendChild(view);

    const onComplete = () => {
        initResizeObserver(container, iframeId, isWeb);
    };

    if (isWeb && context.renderTeXView) {
        context.renderTeXView(onComplete);
    } else if (typeof renderTeXView === 'function') {
        renderTeXView(onComplete);
    } else {
        onComplete();
    }
}

// Function to create a TeX view builder
function createTeXViewBuilder(rootData, teXViewElement, iframeId, isWeb) {
    const { meta, data, style } = rootData;
    const { id, classList, tag, node, rippleEffect } = meta;

    const element = document.createElement(tag);

    if (classList) element.className = classList;
    if (style) element.setAttribute('style', style);
    if (id) element.id = id;

    switch (node) {
        case 'root':
        case 'internal_child': {
            if (Array.isArray(data)) {
                data.forEach(child => {
                    element.appendChild(createTeXViewBuilder(child, teXViewElement, iframeId, isWeb));
                });
            } else {
                element.appendChild(createTeXViewBuilder(data, teXViewElement, iframeId, isWeb));
            }

            if (classList && classList.includes('tex-view-ink-well')) {
                attachRippleClick(element, id, iframeId, rippleEffect, isWeb);
            }
            break;
        }
        case 'leaf': {
            if (tag === 'img') {
                const src = (classList === 'tex-view-asset-image') ? '../../../' + data : data;
                element.setAttribute('src', src);
            } else {
                element.innerHTML = data;
            }
            break;
        }
        default: {
            if (Array.isArray(data)) {
                data.forEach(child => {
                    element.appendChild(createTeXViewBuilder(child, teXViewElement, iframeId, isWeb));
                });
            }
        }
    }
    return element;
}


// Add a simple debounce utility
function debounce(func, wait) {
    let timeout;
    return function (...args) {
        const context = this;
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(context, args), wait);
    };
}

// Wrap the reporting logic
const debouncedReportHeight = debounce((element, iframeId, isWeb) => {
    reportHeight(element, iframeId, isWeb);
}, 100); // Wait 100ms before reporting

function initResizeObserver(element, iframeId, isWeb) {
    // Initial report
    reportHeight(element, iframeId, isWeb);

    if (window.ResizeObserver) {
        const observer = new ResizeObserver(() => {
            // Use the debounced version
            debouncedReportHeight(element, iframeId, isWeb);
        });
        observer.observe(element);
    }
}

// Function to report the height of the TeX view
function reportHeight(element, iframeId, isWeb) {
    const height = getTeXViewHeight(element);

    if (isWeb) {
        if (typeof OnTeXViewRenderedCallback === 'function') {
            OnTeXViewRenderedCallback(height, iframeId);
        }
    } else {
        if (window.OnTeXViewRenderedCallback) {
            OnTeXViewRenderedCallback.postMessage(height);
        }
    }
}

// Function to get the height of the TeX view
function getTeXViewHeight(view) {
    const style = window.getComputedStyle(view);
    const marginTop = parseInt(style.marginTop) || 0;
    const marginBottom = parseInt(style.marginBottom) || 0;
    return view.offsetHeight + marginTop + marginBottom;
}


// Function to attach a ripple click event
function attachRippleClick(element, id, iframeId, rippleEffect, isWeb) {
    element.addEventListener('click', function (e) {
        if (isWeb) {
            if (typeof OnTapCallback === 'function') OnTapCallback(id, iframeId);
        } else {
            if (window.OnTapCallback) OnTapCallback.postMessage(id);
        }

        if (rippleEffect) {
            createRipple(e, this);
        }
    });
}

// Function to create a ripple
function createRipple(event, container) {
    const ripple = document.createElement('div');
    const d = Math.max(container.clientWidth, container.clientHeight);
    const rect = container.getBoundingClientRect();

    ripple.style.width = ripple.style.height = d + 'px';
    ripple.style.left = (event.clientX - rect.left - d / 2) + 'px';
    ripple.style.top = (event.clientY - rect.top - d / 2) + 'px';

    ripple.classList.add('ripple');

    ripple.addEventListener('animationend', () => ripple.remove());
    container.appendChild(ripple);
}

// Function to manage clicks
function clickManager(iframeId, element, id, rippleEffect, isWeb) {
    attachRippleClick(element, id, iframeId, rippleEffect, isWeb);
}

// Function to render completed
function renderCompleted(texViewElement, iframeId, isWeb) {
    reportHeight(texViewElement, iframeId, isWeb);
}