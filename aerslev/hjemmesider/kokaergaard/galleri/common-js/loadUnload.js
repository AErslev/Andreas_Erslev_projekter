 function loadJSFile(){
        var scriptTag = document.createElement("script");
        scriptTag.setAttribute("type", "text/javascript");
        scriptTag.setAttribute("src", "scripts.js");

        var head = document.getElementsByTagName("head")[0];
        head.appendChild(scriptTag);
    }

    function unloadJSFile(){            
        delete window.foo;
        delete window.cleanup;
        alert("cleanedup. typeof window.foo is " + (typeof window.foo));
    }