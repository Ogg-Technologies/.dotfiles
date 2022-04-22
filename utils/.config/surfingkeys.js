api.Hints.style('border: solid 3px #552a48; color:#efe1eb; background: none; background-color: #552a48; font-size: 14px;');

// Unmap everything from "a"
api.unmap('ab');
api.map('F', 'af');
api.unmap('af');


// youtube.com

api.mapkey("a", "click youtube video", function() {
    api.Hints.create("#video-title", api.Hints.dispatchMouseClick);
}, {domain: /youtube.com/i});

api.mapkey("A", "tabnew youtube video", function() {
    api.Hints.create("#video-title", api.Hints.dispatchMouseClick, {tabbed: true});
}, {domain: /youtube.com/i});

const ytGotos = [
    {key:'r', name:'root', url:'https://www.youtube.com/'},
    {key:'s', name:'subs', url:'https://www.youtube.com/feed/subscriptions'},
    {key:'h', name:'history', url:'https://www.youtube.com/feed/history'},
    {key:'l', name:'watch later', url:'https://www.youtube.com/playlist?list=WL'},
];

for (const {key, name, url} of ytGotos) {
    api.mapkey(`<Space>${key}`, `goto ${name}`, function() {
        window.location.href = url;
    }, {domain: /youtube.com/i});
    
    api.mapkey(`<Space>${key.toUpperCase()}`, `tabnew ${name}`, function() {
        api.tabOpenLink(url);
    }, {domain: /youtube.com/i});
}

// google.com
const googleSearchResultSelector = [
  "a h3",
  "h3 a",
  "a[href^='/search']:not(.fl):not(#pnnext,#pnprev):not([role]):not(.hide-focus-ring)",
  "g-scrolling-carousel a",
  ".rc > div:nth-child(2) a",
  ".kno-rdesc a",
  ".kno-fv a",
  ".isv-r > a:first-child",
  ".dbsr > a:first-child",
].join(",")

api.mapkey("a", "open google result", function() {
    api.Hints.create(googleSearchResultSelector, api.Hints.dispatchMouseClick);
}, {domain: /google.com/i});

// set theme
settings.theme = `
.sk_theme {
    font-family: Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #24272e;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #fff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
#sk_status, #sk_find {
    font-size: 20pt;
}`;
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
