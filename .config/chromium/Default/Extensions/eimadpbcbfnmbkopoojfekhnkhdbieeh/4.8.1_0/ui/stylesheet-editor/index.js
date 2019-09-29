(function() {
    "use strict";

    /* malevic@0.17.0 - Aug 19, 2019 */
    function m(tagOrComponent, props, ...children) {
        props = props || {};
        if (typeof tagOrComponent === "string") {
            const tag = tagOrComponent;
            return {type: tag, props, children};
        }
        if (typeof tagOrComponent === "function") {
            const component = tagOrComponent;
            return {type: component, props, children};
        }
        throw new Error("Unsupported spec type");
    }

    /* malevic@0.17.0 - Aug 19, 2019 */
    function createPluginsStore() {
        const plugins = [];
        return {
            add(plugin) {
                plugins.push(plugin);
                return this;
            },
            apply(props) {
                let result;
                let plugin;
                const usedPlugins = new Set();
                for (let i = plugins.length - 1; i >= 0; i--) {
                    plugin = plugins[i];
                    if (usedPlugins.has(plugin)) {
                        continue;
                    }
                    result = plugin(props);
                    if (result != null) {
                        return result;
                    }
                    usedPlugins.add(plugin);
                }
                return null;
            },
            delete(plugin) {
                for (let i = plugins.length - 1; i >= 0; i--) {
                    if (plugins[i] === plugin) {
                        plugins.splice(i, 1);
                        break;
                    }
                }
                return this;
            },
            empty() {
                return plugins.length === 0;
            }
        };
    }
    function iterateComponentPlugins(type, pairs, iterator) {
        pairs
            .filter(([key]) => type[key])
            .forEach(([key, plugins]) => {
                return type[key].forEach((plugin) => iterator(plugins, plugin));
            });
    }
    function addComponentPlugins(type, pairs) {
        iterateComponentPlugins(type, pairs, (plugins, plugin) =>
            plugins.add(plugin)
        );
    }
    function deleteComponentPlugins(type, pairs) {
        iterateComponentPlugins(type, pairs, (plugins, plugin) =>
            plugins.delete(plugin)
        );
    }

    const XHTML_NS = "http://www.w3.org/1999/xhtml";
    const SVG_NS = "http://www.w3.org/2000/svg";
    const PLUGINS_CREATE_ELEMENT = Symbol();
    const pluginsCreateElement = createPluginsStore();
    function createElement(spec, parent) {
        const result = pluginsCreateElement.apply({spec, parent});
        if (result) {
            return result;
        }
        const tag = spec.type;
        if (tag === "svg") {
            return document.createElementNS(SVG_NS, "svg");
        }
        if (parent.namespaceURI === XHTML_NS) {
            return document.createElement(tag);
        }
        return document.createElementNS(parent.namespaceURI, tag);
    }

    function classes(...args) {
        const classes = [];
        args.filter((c) => Boolean(c)).forEach((c) => {
            if (typeof c === "string") {
                classes.push(c);
            } else if (typeof c === "object") {
                classes.push(
                    ...Object.keys(c).filter((key) => Boolean(c[key]))
                );
            }
        });
        return classes.join(" ");
    }
    function setInlineCSSPropertyValue(element, prop, $value) {
        if ($value != null && $value !== "") {
            let value = String($value);
            let important = "";
            if (value.endsWith("!important")) {
                value = value.substring(0, value.length - 10);
                important = "important";
            }
            element.style.setProperty(prop, value, important);
        } else {
            element.style.removeProperty(prop);
        }
    }

    function isObject(value) {
        return value != null && typeof value === "object";
    }

    const eventListeners = new WeakMap();
    function addEventListener(element, event, listener) {
        let listeners;
        if (eventListeners.has(element)) {
            listeners = eventListeners.get(element);
        } else {
            listeners = new Map();
            eventListeners.set(element, listeners);
        }
        if (listeners.get(event) !== listener) {
            if (listeners.has(event)) {
                element.removeEventListener(event, listeners.get(event));
            }
            element.addEventListener(event, listener);
            listeners.set(event, listener);
        }
    }
    function removeEventListener(element, event) {
        if (!eventListeners.has(element)) {
            return;
        }
        const listeners = eventListeners.get(element);
        element.removeEventListener(event, listeners.get(event));
        listeners.delete(event);
    }

    function setClassObject(element, classObj) {
        const cls = Array.isArray(classObj)
            ? classes(...classObj)
            : classes(classObj);
        if (cls) {
            element.setAttribute("class", cls);
        } else {
            element.removeAttribute("class");
        }
    }
    function mergeValues(obj, old) {
        const values = new Map();
        const newProps = new Set(Object.keys(obj));
        const oldProps = Object.keys(old);
        oldProps
            .filter((prop) => !newProps.has(prop))
            .forEach((prop) => values.set(prop, null));
        newProps.forEach((prop) => values.set(prop, obj[prop]));
        return values;
    }
    function setStyleObject(element, styleObj, prev) {
        let prevObj;
        if (isObject(prev)) {
            prevObj = prev;
        } else {
            prevObj = {};
            element.removeAttribute("style");
        }
        const declarations = mergeValues(styleObj, prevObj);
        declarations.forEach(($value, prop) =>
            setInlineCSSPropertyValue(element, prop, $value)
        );
    }
    function setEventListener(element, event, listener) {
        if (typeof listener === "function") {
            addEventListener(element, event, listener);
        } else {
            removeEventListener(element, event);
        }
    }
    const specialAttrs = new Set(["key", "attached", "detached", "updated"]);
    const PLUGINS_SET_ATTRIBUTE = Symbol();
    const pluginsSetAttribute = createPluginsStore();
    function getPropertyValue(obj, prop) {
        return obj && obj.hasOwnProperty(prop) ? obj[prop] : null;
    }
    function syncAttrs(element, attrs, prev) {
        const values = mergeValues(attrs, prev || {});
        values.forEach((value, attr) => {
            if (!pluginsSetAttribute.empty()) {
                const result = pluginsSetAttribute.apply({
                    element,
                    attr,
                    value,
                    get prev() {
                        return getPropertyValue(prev, attr);
                    }
                });
                if (result != null) {
                    return;
                }
            }
            if (attr === "class" && isObject(value)) {
                setClassObject(element, value);
            } else if (attr === "style" && isObject(value)) {
                const prevValue = getPropertyValue(prev, attr);
                setStyleObject(element, value, prevValue);
            } else if (attr.startsWith("on")) {
                const event = attr.substring(2);
                setEventListener(element, event, value);
            } else if (specialAttrs.has(attr));
            else if (value == null || value === false) {
                element.removeAttribute(attr);
            } else {
                element.setAttribute(attr, value === true ? "" : String(value));
            }
        });
    }

    class LinkedList {
        constructor(...items) {
            this.nexts = new WeakMap();
            this.prevs = new WeakMap();
            this.first = null;
            this.last = null;
            items.forEach((item) => this.push(item));
        }
        empty() {
            return this.first == null;
        }
        push(item) {
            if (this.empty()) {
                this.first = item;
                this.last = item;
            } else {
                this.nexts.set(this.last, item);
                this.prevs.set(item, this.last);
                this.last = item;
            }
        }
        insertBefore(newItem, refItem) {
            const prev = this.before(refItem);
            this.prevs.set(newItem, prev);
            this.nexts.set(newItem, refItem);
            this.prevs.set(refItem, newItem);
            prev && this.nexts.set(prev, newItem);
            refItem === this.first && (this.first = newItem);
        }
        delete(item) {
            const prev = this.before(item);
            const next = this.after(item);
            prev && this.nexts.set(prev, next);
            next && this.prevs.set(next, prev);
            item === this.first && (this.first = next);
            item === this.last && (this.last = prev);
        }
        before(item) {
            return this.prevs.get(item) || null;
        }
        after(item) {
            return this.nexts.get(item) || null;
        }
        loop(iterator) {
            if (this.empty()) {
                return;
            }
            let current = this.first;
            do {
                if (iterator(current)) {
                    break;
                }
            } while ((current = this.after(current)));
        }
        copy() {
            const list = new LinkedList();
            this.loop((item) => {
                list.push(item);
                return false;
            });
            return list;
        }
        forEach(iterator) {
            this.loop((item) => {
                iterator(item);
                return false;
            });
        }
        find(iterator) {
            let result = null;
            this.loop((item) => {
                if (iterator(item)) {
                    result = item;
                    return true;
                }
                return false;
            });
            return result;
        }
        map(iterator) {
            const results = [];
            this.loop((item) => {
                results.push(iterator(item));
                return false;
            });
            return results;
        }
    }

    function matchChildren(vnode, old) {
        const oldChildren = old.children();
        const oldChildrenByKey = new Map();
        const oldChildrenWithoutKey = [];
        oldChildren.forEach((v) => {
            const key = v.key();
            if (key == null) {
                oldChildrenWithoutKey.push(v);
            } else {
                oldChildrenByKey.set(key, v);
            }
        });
        const children = vnode.children();
        const matches = [];
        const unmatched = new Set(oldChildren);
        const keys = new Set();
        children.forEach((v) => {
            let match = null;
            let guess = null;
            const key = v.key();
            if (key != null) {
                if (keys.has(key)) {
                    throw new Error("Duplicate key");
                }
                keys.add(key);
                if (oldChildrenByKey.has(key)) {
                    guess = oldChildrenByKey.get(key);
                }
            } else if (oldChildrenWithoutKey.length > 0) {
                guess = oldChildrenWithoutKey.shift();
            }
            if (v.matches(guess)) {
                match = guess;
            }
            matches.push([v, match]);
            if (match) {
                unmatched.delete(match);
            }
        });
        return {matches, unmatched};
    }

    function execute(vnode, old, vdom) {
        const didMatch = vnode && old && vnode.matches(old);
        if (didMatch && vnode.parent() === old.parent()) {
            vdom.replaceVNode(old, vnode);
        } else if (vnode) {
            vdom.addVNode(vnode);
        }
        const context = vdom.getVNodeContext(vnode);
        const oldContext = vdom.getVNodeContext(old);
        if (old && !didMatch) {
            old.detach(oldContext);
            old.children().forEach((v) => execute(null, v, vdom));
            old.detached(oldContext);
        }
        if (vnode && !didMatch) {
            vnode.attach(context);
            vnode.children().forEach((v) => execute(v, null, vdom));
            vnode.attached(context);
        }
        if (didMatch) {
            const result = vnode.update(old, context);
            if (result !== vdom.LEAVE) {
                const {matches, unmatched} = matchChildren(vnode, old);
                unmatched.forEach((v) => execute(null, v, vdom));
                matches.forEach(([v, o]) => execute(v, o, vdom));
                vnode.updated(context);
            }
        }
    }

    function isSpec(x) {
        return isObject(x) && x.type != null && x.nodeType == null;
    }
    function isNodeSpec(x) {
        return isSpec(x) && typeof x.type === "string";
    }
    function isComponentSpec(x) {
        return isSpec(x) && typeof x.type === "function";
    }

    class VNodeBase {
        constructor(parent) {
            this.parentVNode = parent;
        }
        key() {
            return null;
        }
        parent(vnode) {
            if (vnode) {
                this.parentVNode = vnode;
                return;
            }
            return this.parentVNode;
        }
        children() {
            return [];
        }
        attach(context) {}
        detach(context) {}
        update(old, context) {
            return null;
        }
        attached(context) {}
        detached(context) {}
        updated(context) {}
    }
    function nodeMatchesSpec(node, spec) {
        return (
            node instanceof Element && spec.type === node.tagName.toLowerCase()
        );
    }
    const refinedElements = new WeakMap();
    function markElementAsRefined(element, vdom) {
        let refined;
        if (refinedElements.has(vdom)) {
            refined = refinedElements.get(vdom);
        } else {
            refined = new WeakSet();
            refinedElements.set(vdom, refined);
        }
        refined.add(element);
    }
    function isElementRefined(element, vdom) {
        return (
            refinedElements.has(vdom) && refinedElements.get(vdom).has(element)
        );
    }
    class ElementVNode extends VNodeBase {
        constructor(spec, parent) {
            super(parent);
            this.spec = spec;
        }
        matches(other) {
            return (
                other instanceof ElementVNode &&
                this.spec.type === other.spec.type
            );
        }
        key() {
            return this.spec.props.key;
        }
        children() {
            return [this.child];
        }
        getExistingElement(context) {
            const parent = context.parent;
            const existing = context.node;
            let element;
            if (nodeMatchesSpec(existing, this.spec)) {
                element = existing;
            } else if (
                !isElementRefined(parent, context.vdom) &&
                context.vdom.isDOMNodeCaptured(parent)
            ) {
                const sibling = context.sibling;
                const guess = sibling
                    ? sibling.nextElementSibling
                    : parent.firstElementChild;
                if (guess && !context.vdom.isDOMNodeCaptured(guess)) {
                    if (nodeMatchesSpec(guess, this.spec)) {
                        element = guess;
                    } else {
                        parent.removeChild(guess);
                    }
                }
            }
            return element;
        }
        attach(context) {
            let element;
            const existing = this.getExistingElement(context);
            if (existing) {
                element = existing;
            } else {
                element = createElement(this.spec, context.parent);
                markElementAsRefined(element, context.vdom);
            }
            syncAttrs(element, this.spec.props, null);
            this.child = createDOMVNode(element, this.spec.children, this);
        }
        update(prev, context) {
            const prevContext = context.vdom.getVNodeContext(prev);
            const element = prevContext.node;
            syncAttrs(element, this.spec.props, prev.spec.props);
            this.child = createDOMVNode(element, this.spec.children, this);
        }
        attached(context) {
            const {attached} = this.spec.props;
            if (attached) {
                attached(context.node);
            }
        }
        detached(context) {
            const {detached} = this.spec.props;
            if (detached) {
                detached(context.node);
            }
        }
        updated(context) {
            const {updated} = this.spec.props;
            if (updated) {
                updated(context.node);
            }
        }
    }
    const symbols = {
        ATTACHED: Symbol(),
        DETACHED: Symbol(),
        UPDATED: Symbol()
    };
    const domPlugins = [
        [PLUGINS_CREATE_ELEMENT, pluginsCreateElement],
        [PLUGINS_SET_ATTRIBUTE, pluginsSetAttribute]
    ];
    class ComponentVNode extends VNodeBase {
        constructor(spec, parent) {
            super(parent);
            this.lock = false;
            this.spec = spec;
            this.prev = null;
            this.store = {};
        }
        matches(other) {
            return (
                other instanceof ComponentVNode &&
                this.spec.type === other.spec.type
            );
        }
        key() {
            return this.spec.props.key;
        }
        children() {
            return [this.child];
        }
        createContext(context) {
            const {parent} = context;
            const {spec, prev, store} = this;
            return {
                spec,
                prev,
                store,
                get node() {
                    return context.node;
                },
                get nodes() {
                    return context.nodes;
                },
                parent,
                attached: (fn) => (store[symbols.ATTACHED] = fn),
                detached: (fn) => (store[symbols.DETACHED] = fn),
                updated: (fn) => (store[symbols.UPDATED] = fn),
                refresh: () => {
                    if (this.lock) {
                        throw new Error(
                            "Calling refresh during unboxing causes infinite loop"
                        );
                    }
                    this.prev = this.spec;
                    const latestContext = context.vdom.getVNodeContext(this);
                    const unboxed = this.unbox(latestContext);
                    if (unboxed === context.vdom.LEAVE) {
                        return;
                    }
                    const prevChild = this.child;
                    this.child = createVNode(unboxed, this);
                    context.vdom.execute(this.child, prevChild);
                },
                leave: () => context.vdom.LEAVE
            };
        }
        unbox(context) {
            const Component = this.spec.type;
            const props = this.spec.props;
            const children = this.spec.children;
            this.lock = true;
            const prevContext = ComponentVNode.context;
            ComponentVNode.context = this.createContext(context);
            let unboxed = null;
            try {
                unboxed = Component(props, ...children);
            } finally {
                ComponentVNode.context = prevContext;
                this.lock = false;
            }
            return unboxed;
        }
        addPlugins() {
            addComponentPlugins(this.spec.type, domPlugins);
        }
        deletePlugins() {
            deleteComponentPlugins(this.spec.type, domPlugins);
        }
        attach(context) {
            this.addPlugins();
            const unboxed = this.unbox(context);
            const childSpec = unboxed === context.vdom.LEAVE ? null : unboxed;
            this.child = createVNode(childSpec, this);
        }
        update(prev, context) {
            this.store = prev.store;
            this.prev = prev.spec;
            const prevContext = context.vdom.getVNodeContext(prev);
            this.addPlugins();
            const unboxed = this.unbox(prevContext);
            let result = null;
            if (unboxed === context.vdom.LEAVE) {
                result = unboxed;
                this.child = prev.child;
                context.vdom.adoptVNode(this.child, this);
            } else {
                this.child = createVNode(unboxed, this);
            }
            return result;
        }
        handle(event, context) {
            const fn = this.store[event];
            if (fn) {
                const nodes =
                    context.nodes.length === 0 ? [null] : context.nodes;
                fn(...nodes);
            }
        }
        attached(context) {
            this.deletePlugins();
            this.handle(symbols.ATTACHED, context);
        }
        detached(context) {
            this.handle(symbols.DETACHED, context);
        }
        updated(context) {
            this.deletePlugins();
            this.handle(symbols.UPDATED, context);
        }
    }
    ComponentVNode.context = null;
    class TextVNode extends VNodeBase {
        constructor(text, parent) {
            super(parent);
            this.text = text;
        }
        matches(other) {
            return other instanceof TextVNode;
        }
        children() {
            return [this.child];
        }
        getExistingNode(context) {
            const {parent} = context;
            let node;
            if (context.node instanceof Text) {
                node = context.node;
            } else if (
                !isElementRefined(parent, context.vdom) &&
                context.vdom.isDOMNodeCaptured(parent)
            ) {
                const sibling = context.sibling;
                const guess = sibling ? sibling.nextSibling : parent.firstChild;
                if (
                    guess &&
                    !context.vdom.isDOMNodeCaptured(guess) &&
                    guess instanceof Text
                ) {
                    node = guess;
                }
            }
            return node;
        }
        attach(context) {
            const existing = this.getExistingNode(context);
            let node;
            if (existing) {
                node = existing;
                node.textContent = this.text;
            } else {
                node = document.createTextNode(this.text);
            }
            this.child = createVNode(node, this);
        }
        update(prev, context) {
            const prevContext = context.vdom.getVNodeContext(prev);
            const {node} = prevContext;
            if (this.text !== prev.text) {
                node.textContent = this.text;
            }
            this.child = createVNode(node, this);
        }
    }
    class InlineFunctionVNode extends VNodeBase {
        constructor(fn, parent) {
            super(parent);
            this.fn = fn;
        }
        matches(other) {
            return other instanceof InlineFunctionVNode;
        }
        children() {
            return [this.child];
        }
        call(context) {
            const fn = this.fn;
            const inlineFnContext = {
                parent: context.parent,
                get node() {
                    return context.node;
                },
                get nodes() {
                    return context.nodes;
                }
            };
            const result = fn(inlineFnContext);
            this.child = createVNode(result, this);
        }
        attach(context) {
            this.call(context);
        }
        update(prev, context) {
            const prevContext = context.vdom.getVNodeContext(prev);
            this.call(prevContext);
        }
    }
    class NullVNode extends VNodeBase {
        matches(other) {
            return other instanceof NullVNode;
        }
    }
    class DOMVNode extends VNodeBase {
        constructor(node, childSpecs, parent) {
            super(parent);
            this.node = node;
            this.childSpecs = childSpecs;
        }
        matches(other) {
            return other instanceof DOMVNode && this.node === other.node;
        }
        wrap() {
            this.childVNodes = this.childSpecs.map((spec) =>
                createVNode(spec, this)
            );
        }
        insertNode(context) {
            const {parent, sibling} = context;
            const shouldInsert = !(
                parent === this.node.parentElement &&
                sibling === this.node.previousSibling
            );
            if (shouldInsert) {
                const target = sibling
                    ? sibling.nextSibling
                    : parent.firstChild;
                parent.insertBefore(this.node, target);
            }
        }
        attach(context) {
            this.wrap();
            this.insertNode(context);
        }
        detach(context) {
            context.parent.removeChild(this.node);
        }
        update(prev, context) {
            this.wrap();
            this.insertNode(context);
        }
        refine(context) {
            const element = this.node;
            for (let current = element.lastChild; current != null; ) {
                if (context.vdom.isDOMNodeCaptured(current)) {
                    current = current.previousSibling;
                } else {
                    const prev = current.previousSibling;
                    element.removeChild(current);
                    current = prev;
                }
            }
            markElementAsRefined(element, context.vdom);
        }
        attached(context) {
            const {node} = this;
            if (
                node instanceof Element &&
                !isElementRefined(node, context.vdom) &&
                context.vdom.isDOMNodeCaptured(node)
            ) {
                this.refine(context);
            }
        }
        children() {
            return this.childVNodes;
        }
    }
    function isDOMVNode(v) {
        return v instanceof DOMVNode;
    }
    function createDOMVNode(node, childSpecs, parent) {
        return new DOMVNode(node, childSpecs, parent);
    }
    class ArrayVNode extends VNodeBase {
        constructor(items, key, parent) {
            super(parent);
            this.items = items;
            this.id = key;
        }
        matches(other) {
            return other instanceof ArrayVNode;
        }
        key() {
            return this.id;
        }
        children() {
            return this.childVNodes;
        }
        wrap() {
            this.childVNodes = this.items.map((spec) =>
                createVNode(spec, this)
            );
        }
        attach() {
            this.wrap();
        }
        update() {
            this.wrap();
        }
    }
    function createVNode(spec, parent) {
        if (isNodeSpec(spec)) {
            return new ElementVNode(spec, parent);
        }
        if (isComponentSpec(spec)) {
            if (spec.type === Array) {
                return new ArrayVNode(spec.children, spec.props.key, parent);
            }
            return new ComponentVNode(spec, parent);
        }
        if (typeof spec === "string") {
            return new TextVNode(spec, parent);
        }
        if (spec == null) {
            return new NullVNode(parent);
        }
        if (typeof spec === "function") {
            return new InlineFunctionVNode(spec, parent);
        }
        if (spec instanceof Node) {
            return createDOMVNode(spec, [], parent);
        }
        if (Array.isArray(spec)) {
            return new ArrayVNode(spec, null, parent);
        }
        throw new Error("Unable to create virtual node for spec");
    }

    function createVDOM(rootNode) {
        const contexts = new WeakMap();
        const hubs = new WeakMap();
        const parentNodes = new WeakMap();
        const passingLinks = new WeakMap();
        const linkedParents = new WeakSet();
        const LEAVE = Symbol();
        function execute$1(vnode, old) {
            execute(vnode, old, vdom);
        }
        function creatVNodeContext(vnode) {
            const parentNode = parentNodes.get(vnode);
            contexts.set(vnode, {
                parent: parentNode,
                get node() {
                    const linked = passingLinks
                        .get(vnode)
                        .find((link) => link.node != null);
                    return linked ? linked.node : null;
                },
                get nodes() {
                    return passingLinks
                        .get(vnode)
                        .map((link) => link.node)
                        .filter((node) => node);
                },
                get sibling() {
                    if (parentNode === rootNode.parentElement) {
                        return passingLinks.get(vnode).first.node
                            .previousSibling;
                    }
                    const hub = hubs.get(parentNode);
                    let current = passingLinks.get(vnode).first;
                    while ((current = hub.links.before(current))) {
                        if (current.node) {
                            return current.node;
                        }
                    }
                    return null;
                },
                vdom
            });
        }
        function createRootVNodeLinks(vnode) {
            const parentNode =
                rootNode.parentElement || document.createDocumentFragment();
            const node = rootNode;
            const links = new LinkedList({
                parentNode,
                node
            });
            passingLinks.set(vnode, links.copy());
            parentNodes.set(vnode, parentNode);
            hubs.set(parentNode, {
                node: parentNode,
                links
            });
        }
        function createVNodeLinks(vnode) {
            const parent = vnode.parent();
            const isBranch = linkedParents.has(parent);
            const parentNode = isDOMVNode(parent)
                ? parent.node
                : parentNodes.get(parent);
            parentNodes.set(vnode, parentNode);
            const vnodeLinks = new LinkedList();
            passingLinks.set(vnode, vnodeLinks);
            if (isBranch) {
                const newLink = {
                    parentNode,
                    node: null
                };
                let current = vnode;
                do {
                    passingLinks.get(current).push(newLink);
                    current = current.parent();
                } while (current && !isDOMVNode(current));
                hubs.get(parentNode).links.push(newLink);
            } else {
                linkedParents.add(parent);
                const links = isDOMVNode(parent)
                    ? hubs.get(parentNode).links
                    : passingLinks.get(parent);
                links.forEach((link) => vnodeLinks.push(link));
            }
        }
        function connectDOMVNode(vnode) {
            if (isDOMVNode(vnode)) {
                const {node} = vnode;
                hubs.set(node, {
                    node,
                    links: new LinkedList({
                        parentNode: node,
                        node: null
                    })
                });
                passingLinks.get(vnode).forEach((link) => (link.node = node));
            }
        }
        function addVNode(vnode) {
            const parent = vnode.parent();
            if (parent == null) {
                createRootVNodeLinks(vnode);
            } else {
                createVNodeLinks(vnode);
            }
            connectDOMVNode(vnode);
            creatVNodeContext(vnode);
        }
        function getVNodeContext(vnode) {
            return contexts.get(vnode);
        }
        function getAncestorsLinks(vnode) {
            const parentNode = parentNodes.get(vnode);
            const hub = hubs.get(parentNode);
            const allLinks = [];
            let current = vnode;
            while ((current = current.parent()) && !isDOMVNode(current)) {
                allLinks.push(passingLinks.get(current));
            }
            allLinks.push(hub.links);
            return allLinks;
        }
        function replaceVNode(old, vnode) {
            if (vnode.parent() == null) {
                addVNode(vnode);
                return;
            }
            const oldContext = contexts.get(old);
            const {parent: parentNode} = oldContext;
            parentNodes.set(vnode, parentNode);
            const oldLinks = passingLinks.get(old);
            const newLink = {
                parentNode,
                node: null
            };
            getAncestorsLinks(vnode).forEach((links) => {
                const nextLink = links.after(oldLinks.last);
                oldLinks.forEach((link) => links.delete(link));
                if (nextLink) {
                    links.insertBefore(newLink, nextLink);
                } else {
                    links.push(newLink);
                }
            });
            const vnodeLinks = new LinkedList(newLink);
            passingLinks.set(vnode, vnodeLinks);
            creatVNodeContext(vnode);
        }
        function adoptVNode(vnode, parent) {
            const vnodeLinks = passingLinks.get(vnode);
            const parentLinks = passingLinks.get(parent).copy();
            vnode.parent(parent);
            getAncestorsLinks(vnode).forEach((links) => {
                vnodeLinks.forEach((link) =>
                    links.insertBefore(link, parentLinks.first)
                );
                parentLinks.forEach((link) => links.delete(link));
            });
        }
        function isDOMNodeCaptured(node) {
            return hubs.has(node) && node !== rootNode.parentElement;
        }
        const vdom = {
            execute: execute$1,
            addVNode,
            getVNodeContext,
            replaceVNode,
            adoptVNode,
            isDOMNodeCaptured,
            LEAVE
        };
        return vdom;
    }

    const roots = new WeakMap();
    const vdoms = new WeakMap();
    function realize(node, vnode) {
        const old = roots.get(node) || null;
        roots.set(node, vnode);
        let vdom;
        if (vdoms.has(node)) {
            vdom = vdoms.get(node);
        } else {
            vdom = createVDOM(node);
            vdoms.set(node, vdom);
        }
        vdom.execute(vnode, old);
        return vdom.getVNodeContext(vnode);
    }
    function sync(node, spec) {
        const vnode = createVNode(spec, null);
        const context = realize(node, vnode);
        const {nodes} = context;
        if (nodes.length !== 1 || nodes[0] !== node) {
            throw new Error("Spec does not match the node");
        }
        return nodes[0];
    }

    function classes$1(...args) {
        const classes = [];
        args.filter((c) => Boolean(c)).forEach((c) => {
            if (typeof c === "string") {
                classes.push(c);
            } else if (typeof c === "object") {
                classes.push(
                    ...Object.keys(c).filter((key) => Boolean(c[key]))
                );
            }
        });
        return classes.join(" ");
    }

    function toArray(x) {
        return Array.isArray(x) ? x : [x];
    }
    function mergeClass(cls, propsCls) {
        const normalized = toArray(cls).concat(toArray(propsCls));
        return classes$1(...normalized);
    }
    function omitAttrs(omit, attrs) {
        const result = {};
        Object.keys(attrs).forEach((key) => {
            if (omit.indexOf(key) < 0) {
                result[key] = attrs[key];
            }
        });
        return result;
    }

    function Button(props, ...children) {
        const cls = mergeClass("button", props.class);
        const attrs = omitAttrs(["class"], props);
        return m(
            "button",
            Object.assign({class: cls}, attrs),
            m("span", {class: "button__wrapper"}, children)
        );
    }

    function getUILanguage() {
        return chrome.i18n.getUILanguage();
    }

    const is12H = new Date().toLocaleTimeString(getUILanguage()).endsWith("M");

    function getURLHost(url) {
        return url.match(/^(.*?\/{2,3})?(.+?)(\/|$)/)[2];
    }
    function isURLInList(url, list) {
        for (let i = 0; i < list.length; i++) {
            if (isURLMatched(url, list[i])) {
                return true;
            }
        }
        return false;
    }
    function isURLMatched(url, urlTemplate) {
        const regex = createUrlRegex(urlTemplate);
        return Boolean(url.match(regex));
    }
    function createUrlRegex(urlTemplate) {
        urlTemplate = urlTemplate.trim();
        const exactBeginning = urlTemplate[0] === "^";
        const exactEnding = urlTemplate[urlTemplate.length - 1] === "$";
        urlTemplate = urlTemplate
            .replace(/^\^/, "")
            .replace(/\$$/, "")
            .replace(/^.*?\/{2,3}/, "")
            .replace(/\?.*$/, "")
            .replace(/\/$/, "");
        let slashIndex;
        let beforeSlash;
        let afterSlash;
        if ((slashIndex = urlTemplate.indexOf("/")) >= 0) {
            beforeSlash = urlTemplate.substring(0, slashIndex);
            afterSlash = urlTemplate.replace("$", "").substring(slashIndex);
        } else {
            beforeSlash = urlTemplate.replace("$", "");
        }
        let result = exactBeginning
            ? "^(.*?\\:\\/{2,3})?"
            : "^(.*?\\:\\/{2,3})?([^/]*?\\.)?";
        const hostParts = beforeSlash.split(".");
        result += "(";
        for (let i = 0; i < hostParts.length; i++) {
            if (hostParts[i] === "*") {
                hostParts[i] = "[^\\.\\/]+?";
            }
        }
        result += hostParts.join("\\.");
        result += ")";
        if (afterSlash) {
            result += "(";
            result += afterSlash.replace("/", "\\/");
            result += ")";
        }
        result += exactEnding ? "(\\/?(\\?[^/]*?)?)$" : "(\\/?.*?)$";
        return new RegExp(result, "i");
    }

    function Body({data, tab, actions}) {
        const host = getURLHost(tab.url);
        const custom = data.settings.customThemes.find(({url}) =>
            isURLInList(tab.url, url)
        );
        let textNode;
        const placeholderText = [
            "* {",
            "    background-color: #234 !important;",
            "    color: #cba !important;",
            "}"
        ].join("\n");
        function onTextRender(node) {
            textNode = node;
            textNode.value =
                (custom
                    ? custom.theme.stylesheet
                    : data.settings.theme.stylesheet) || "";
            if (document.activeElement !== textNode) {
                textNode.focus();
            }
        }
        function applyStyleSheet(css) {
            if (custom) {
                custom.theme = {...custom.theme, ...{stylesheet: css}};
                actions.changeSettings({
                    customThemes: data.settings.customThemes
                });
            } else {
                actions.setTheme({stylesheet: css});
            }
        }
        function reset() {
            applyStyleSheet("");
        }
        function apply() {
            const css = textNode.value;
            applyStyleSheet(css);
        }
        return m(
            "body",
            null,
            m(
                "header",
                null,
                m("img", {
                    id: "logo",
                    src: "../assets/images/darkreader-type.svg",
                    alt: "Dark Reader"
                }),
                m("h1", {id: "title"}, "CSS Editor")
            ),
            m("h3", {id: "sub-title"}, custom ? host : "All websites"),
            m("textarea", {
                id: "editor",
                native: true,
                placeholder: placeholderText,
                attached: onTextRender,
                updated: onTextRender
            }),
            m(
                "div",
                {id: "buttons"},
                m(Button, {onclick: reset}, "Reset"),
                m(Button, {onclick: apply}, "Apply")
            )
        );
    }

    class Connector {
        constructor() {
            this.counter = 0;
            this.port = chrome.runtime.connect({name: "ui"});
        }
        getRequestId() {
            return ++this.counter;
        }
        sendRequest(request, executor) {
            const id = this.getRequestId();
            return new Promise((resolve, reject) => {
                const listener = ({id: responseId, ...response}) => {
                    if (responseId === id) {
                        executor(response, resolve, reject);
                        this.port.onMessage.removeListener(listener);
                    }
                };
                this.port.onMessage.addListener(listener);
                this.port.postMessage({...request, id});
            });
        }
        getData() {
            return this.sendRequest({type: "get-data"}, ({data}, resolve) =>
                resolve(data)
            );
        }
        getActiveTabInfo() {
            return this.sendRequest(
                {type: "get-active-tab-info"},
                ({data}, resolve) => resolve(data)
            );
        }
        subscribeToChanges(callback) {
            const id = this.getRequestId();
            this.port.onMessage.addListener(({id: responseId, data}) => {
                if (responseId === id) {
                    callback(data);
                }
            });
            this.port.postMessage({type: "subscribe-to-changes", id});
        }
        enable() {
            this.port.postMessage({type: "enable"});
        }
        disable() {
            this.port.postMessage({type: "disable"});
        }
        setShortcut(command, shortcut) {
            this.port.postMessage({
                type: "set-shortcut",
                data: {command, shortcut}
            });
        }
        changeSettings(settings) {
            this.port.postMessage({type: "change-settings", data: settings});
        }
        setTheme(theme) {
            this.port.postMessage({type: "set-theme", data: theme});
        }
        toggleSitePattern(pattern) {
            this.port.postMessage({type: "toggle-site-pattern", data: pattern});
        }
        markNewsAsRead(ids) {
            this.port.postMessage({type: "mark-news-as-read", data: ids});
        }
        applyDevDynamicThemeFixes(text) {
            return this.sendRequest(
                {type: "apply-dev-dynamic-theme-fixes", data: text},
                ({error}, resolve, reject) =>
                    error ? reject(error) : resolve()
            );
        }
        resetDevDynamicThemeFixes() {
            this.port.postMessage({type: "reset-dev-dynamic-theme-fixes"});
        }
        applyDevInversionFixes(text) {
            return this.sendRequest(
                {type: "apply-dev-inversion-fixes", data: text},
                ({error}, resolve, reject) =>
                    error ? reject(error) : resolve()
            );
        }
        resetDevInversionFixes() {
            this.port.postMessage({type: "reset-dev-inversion-fixes"});
        }
        applyDevStaticThemes(text) {
            return this.sendRequest(
                {type: "apply-dev-static-themes", data: text},
                ({error}, resolve, reject) =>
                    error ? reject(error) : resolve()
            );
        }
        resetDevStaticThemes() {
            this.port.postMessage({type: "reset-dev-static-themes"});
        }
        disconnect() {
            this.port.disconnect();
        }
    }

    function getMockData(override = {}) {
        return Object.assign(
            {
                isEnabled: true,
                isReady: true,
                settings: {
                    enabled: true,
                    theme: {
                        mode: 1,
                        brightness: 110,
                        contrast: 90,
                        grayscale: 20,
                        sepia: 10,
                        useFont: false,
                        fontFamily: "Segoe UI",
                        textStroke: 0,
                        engine: "cssFilter",
                        stylesheet: ""
                    },
                    customThemes: [],
                    siteList: [],
                    applyToListedOnly: false,
                    changeBrowserTheme: false,
                    notifyOfNews: false,
                    syncSettings: true,
                    automation: "",
                    time: {
                        activation: "18:00",
                        deactivation: "9:00"
                    },
                    location: {
                        latitude: 52.4237178,
                        longitude: 31.021786
                    }
                },
                fonts: [
                    "serif",
                    "sans-serif",
                    "monospace",
                    "cursive",
                    "fantasy",
                    "system-ui"
                ],
                news: [],
                shortcuts: {
                    addSite: "Alt+Shift+A",
                    toggle: "Alt+Shift+D"
                },
                devtools: {
                    dynamicFixesText: "",
                    filterFixesText: "",
                    staticThemesText: "",
                    hasCustomDynamicFixes: false,
                    hasCustomFilterFixes: false,
                    hasCustomStaticFixes: false
                }
            },
            override
        );
    }
    function getMockActiveTabInfo() {
        return {
            url: "https://darkreader.org/",
            isProtected: false,
            isInDarkList: false
        };
    }
    function createConnectorMock() {
        let listener = null;
        const data = getMockData();
        const tab = getMockActiveTabInfo();
        const connector = {
            getData() {
                return Promise.resolve(data);
            },
            getActiveTabInfo() {
                return Promise.resolve(tab);
            },
            subscribeToChanges(callback) {
                listener = callback;
            },
            changeSettings(settings) {
                Object.assign(data.settings, settings);
                listener(data);
            },
            setTheme(theme) {
                Object.assign(data.settings.theme, theme);
                listener(data);
            },
            setShortcut(command, shortcut) {
                Object.assign(data.shortcuts, {[command]: shortcut});
                listener(data);
            },
            toggleSitePattern(pattern) {
                const index = data.settings.siteList.indexOf(pattern);
                if (index >= 0) {
                    data.settings.siteList.splice(pattern, 1);
                } else {
                    data.settings.siteList.push(pattern);
                }
                listener(data);
            },
            markNewsAsRead(ids) {
                data.news
                    .filter(({id}) => ids.includes(id))
                    .forEach((news) => (news.read = true));
                listener(data);
            },
            disconnect() {}
        };
        return connector;
    }

    function connect() {
        if (typeof chrome === "undefined" || !chrome.extension) {
            return createConnectorMock();
        }
        return new Connector();
    }

    function renderBody(data, tab, actions) {
        sync(document.body, m(Body, {data: data, tab: tab, actions: actions}));
    }
    async function start() {
        const connector = connect();
        window.addEventListener("unload", () => connector.disconnect());
        const data = await connector.getData();
        const tab = await connector.getActiveTabInfo();
        renderBody(data, tab, connector);
        connector.subscribeToChanges((data) =>
            renderBody(data, tab, connector)
        );
    }
    start();
})();
