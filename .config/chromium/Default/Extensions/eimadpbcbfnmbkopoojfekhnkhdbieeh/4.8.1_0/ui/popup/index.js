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
    function createPluginsAPI(key) {
        const api = {
            add(type, plugin) {
                if (!type[key]) {
                    type[key] = [];
                }
                type[key].push(plugin);
                return api;
            }
        };
        return api;
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
    function getComponentContext() {
        return ComponentVNode.context;
    }
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
    function render(element, spec) {
        const vnode = createDOMVNode(
            element,
            Array.isArray(spec) ? spec : [spec],
            null
        );
        realize(element, vnode);
        return element;
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

    const plugins = {
        createElement: createPluginsAPI(PLUGINS_CREATE_ELEMENT),
        setAttribute: createPluginsAPI(PLUGINS_SET_ATTRIBUTE)
    };

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

    /* malevic@0.17.0 - Aug 19, 2019 */

    function withForms(type) {
        plugins.setAttribute.add(type, ({element, attr, value}) => {
            if (attr === "value" && element instanceof HTMLInputElement) {
                const text = (element.value = value == null ? "" : value);
                element.value = text;
                return true;
            }
            return null;
        });
        return type;
    }

    /* malevic@0.17.0 - Aug 19, 2019 */

    let currentUseStateFn = null;
    function useState(initialState) {
        if (!currentUseStateFn) {
            throw new Error("`useState()` should be called inside a component");
        }
        return currentUseStateFn(initialState);
    }
    function withState(type) {
        const Stateful = (props, ...children) => {
            const context = getComponentContext();
            const useState = (initial) => {
                if (!context) {
                    return {state: initial, setState: null};
                }
                const {store, refresh} = context;
                store.state = store.state || initial;
                const setState = (newState) => {
                    if (lock) {
                        throw new Error(
                            "Setting state during unboxing causes infinite loop"
                        );
                    }
                    store.state = Object.assign({}, store.state, newState);
                    refresh();
                };
                return {
                    state: store.state,
                    setState
                };
            };
            let lock = true;
            const prevUseStateFn = currentUseStateFn;
            currentUseStateFn = useState;
            let result;
            try {
                result = type(props, ...children);
            } finally {
                currentUseStateFn = prevUseStateFn;
                lock = false;
            }
            return result;
        };
        return Stateful;
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
    function compose(type, ...wrappers) {
        return wrappers.reduce((t, w) => w(t), type);
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

    function CheckBox(props, ...children) {
        const cls = mergeClass("checkbox", props.class);
        const attrs = omitAttrs(["class", "checked", "onchange"], props);
        const check = (domNode) => (domNode.checked = Boolean(props.checked));
        return m(
            "label",
            Object.assign({class: cls}, attrs),
            m("input", {
                class: "checkbox__input",
                type: "checkbox",
                checked: props.checked,
                onchange: props.onchange,
                attached: check,
                updated: check
            }),
            m("span", {class: "checkbox__checkmark"}),
            m("span", {class: "checkbox__content"}, children)
        );
    }

    function MultiSwitch(props) {
        return m(
            "span",
            {class: ["multi-switch", props.class]},
            m("span", {
                class: "multi-switch__highlight",
                style: {
                    left: `${(props.options.indexOf(props.value) /
                        props.options.length) *
                        100}%`,
                    width: `${(1 / props.options.length) * 100}%`
                }
            }),
            props.options.map((option) =>
                m(
                    "span",
                    {
                        class: {
                            "multi-switch__option": true,
                            "multi-switch__option--selected":
                                option === props.value
                        },
                        onclick: () =>
                            option !== props.value && props.onChange(option)
                    },
                    option
                )
            )
        );
    }

    function TextBox(props) {
        const cls = mergeClass("textbox", props.class);
        const attrs = omitAttrs(["class", "type"], props);
        return m("input", Object.assign({class: cls, type: "text"}, attrs));
    }

    function VirtualScroll(props) {
        if (props.items.length === 0) {
            return props.root;
        }
        const {store} = getComponentContext();
        function renderContent(root, scrollToIndex) {
            if (store.itemHeight == null) {
                const tempItem = {
                    ...props.items[0],
                    props: {
                        ...props.items[0].props,
                        attached: null,
                        updated: null
                    }
                };
                const tempNode = render(root, tempItem).firstElementChild;
                store.itemHeight = tempNode.getBoundingClientRect().height;
            }
            const {itemHeight} = store;
            const wrapper = render(
                root,
                m("div", {
                    style: {
                        flex: "none",
                        height: `${props.items.length * itemHeight}px`,
                        overflow: "hidden",
                        position: "relative"
                    }
                })
            ).firstElementChild;
            if (scrollToIndex >= 0) {
                root.scrollTop = scrollToIndex * itemHeight;
            }
            const containerHeight =
                document.documentElement.clientHeight -
                root.getBoundingClientRect().top;
            let focusedIndex = -1;
            if (document.activeElement) {
                let current = document.activeElement;
                while (current && current.parentElement !== wrapper) {
                    current = current.parentElement;
                }
                if (current) {
                    focusedIndex = store.nodesIndices.get(current);
                }
            }
            store.nodesIndices = store.nodesIndices || new WeakMap();
            const saveNodeIndex = (node, index) =>
                store.nodesIndices.set(node, index);
            const items = props.items
                .map((item, index) => {
                    return {item, index};
                })
                .filter(({index}) => {
                    const eTop = index * itemHeight;
                    const eBottom = (index + 1) * itemHeight;
                    const rTop = root.scrollTop;
                    const rBottom = root.scrollTop + containerHeight;
                    const isTopBoundVisible = eTop >= rTop && eTop <= rBottom;
                    const isBottomBoundVisible =
                        eBottom >= rTop && eBottom <= rBottom;
                    return (
                        isTopBoundVisible ||
                        isBottomBoundVisible ||
                        focusedIndex === index
                    );
                })
                .map(({item, index}) =>
                    m(
                        "div",
                        {
                            key: index,
                            attached: (node) => saveNodeIndex(node, index),
                            updated: (node) => saveNodeIndex(node, index),
                            style: {
                                left: "0",
                                position: "absolute",
                                top: `${index * itemHeight}px`,
                                width: "100%"
                            }
                        },
                        item
                    )
                );
            render(wrapper, items);
        }
        let rootNode;
        let prevScrollTop;
        const rootDidMount = props.root.props.attached;
        const rootDidUpdate = props.root.props.updated;
        return {
            ...props.root,
            props: {
                ...props.root.props,
                attached: (node) => {
                    rootNode = node;
                    rootDidMount && rootDidMount(rootNode);
                    renderContent(
                        rootNode,
                        isNaN(props.scrollToIndex) ? -1 : props.scrollToIndex
                    );
                },
                updated: (node) => {
                    rootNode = node;
                    rootDidUpdate && rootDidUpdate(rootNode);
                    renderContent(
                        rootNode,
                        isNaN(props.scrollToIndex) ? -1 : props.scrollToIndex
                    );
                },
                onscroll: () => {
                    if (rootNode.scrollTop === prevScrollTop) {
                        return;
                    }
                    prevScrollTop = rootNode.scrollTop;
                    renderContent(rootNode, -1);
                }
            },
            children: []
        };
    }

    function Select(props) {
        const {state, setState} = useState({
            isExpanded: false,
            focusedIndex: null
        });
        const values = Object.keys(props.options);
        const {store} = getComponentContext();
        const valueNodes = store.valueNodes || (store.valueNodes = new Map());
        const nodesValues =
            store.nodesValues || (store.nodesValues = new WeakMap());
        function onRender(node) {
            store.rootNode = node;
        }
        function onOuterClick(e) {
            const r = store.rootNode.getBoundingClientRect();
            if (
                e.clientX < r.left ||
                e.clientX > r.right ||
                e.clientY < r.top ||
                e.clientY > r.bottom
            ) {
                window.removeEventListener("click", onOuterClick);
                collapseList();
            }
        }
        function onTextInput(e) {
            const text = e.target.value.toLowerCase().trim();
            expandList();
            values.some((value) => {
                if (value.toLowerCase().indexOf(text) === 0) {
                    scrollToValue(value);
                    return true;
                }
            });
        }
        function onKeyPress(e) {
            const input = e.target;
            if (e.key === "Enter") {
                const value = input.value;
                input.blur();
                collapseList();
                props.onChange(value);
            }
        }
        function scrollToValue(value) {
            setState({focusedIndex: values.indexOf(value)});
        }
        function onExpandClick() {
            if (state.isExpanded) {
                collapseList();
            } else {
                expandList();
            }
        }
        function expandList() {
            setState({isExpanded: true});
            scrollToValue(props.value);
            window.addEventListener("click", onOuterClick);
        }
        function collapseList() {
            setState({isExpanded: false});
        }
        function onSelectOption(e) {
            let current = e.target;
            while (current && !nodesValues.has(current)) {
                current = current.parentElement;
            }
            if (current) {
                const value = nodesValues.get(current);
                props.onChange(value);
            }
            collapseList();
        }
        function saveValueNode(value, domNode) {
            valueNodes.set(value, domNode);
            nodesValues.set(domNode, value);
        }
        function removeValueNode(value) {
            const el = valueNodes.get(value);
            valueNodes.delete(value);
            nodesValues.delete(el);
        }
        return m(
            "span",
            {class: "select", attached: onRender, updated: onRender},
            m(
                "span",
                {class: "select__line"},
                m(TextBox, {
                    class: "select__textbox",
                    value: props.value,
                    oninput: onTextInput,
                    onkeypress: onKeyPress
                }),
                m(
                    Button,
                    {class: "select__expand", onclick: onExpandClick},
                    m("span", {class: "select__expand__icon"})
                )
            ),
            m(VirtualScroll, {
                root: m("span", {
                    class: {
                        "select__list": true,
                        "select__list--expanded": state.isExpanded,
                        "select__list--short":
                            Object.keys(props.options).length <= 7
                    },
                    onclick: onSelectOption
                }),
                items: Object.entries(props.options).map(([value, content]) =>
                    m(
                        "span",
                        {
                            class: "select__option",
                            data: value,
                            attached: (domNode) =>
                                saveValueNode(value, domNode),
                            updated: (domNode) => saveValueNode(value, domNode),
                            detached: () => removeValueNode(value)
                        },
                        content
                    )
                ),
                scrollToIndex: state.focusedIndex
            })
        );
    }
    var Select$1 = withState(Select);

    function isFirefox() {
        return navigator.userAgent.includes("Firefox");
    }
    function isVivaldi() {
        return navigator.userAgent.toLowerCase().includes("vivaldi");
    }
    function isYaBrowser() {
        return navigator.userAgent.toLowerCase().includes("yabrowser");
    }
    function isOpera() {
        const agent = navigator.userAgent.toLowerCase();
        return agent.includes("opr") || agent.includes("opera");
    }
    function isEdge() {
        return navigator.userAgent.includes("Edg");
    }
    function isWindows() {
        return navigator.platform.toLowerCase().startsWith("win");
    }
    function isMacOS() {
        return navigator.platform.toLowerCase().startsWith("mac");
    }
    function isMobile() {
        const agent = navigator.userAgent.toLowerCase();
        return agent.includes("mobile");
    }
    function getChromeVersion() {
        const agent = navigator.userAgent.toLowerCase();
        const m = agent.match(/chrom[e|ium]\/([^ ]+)/);
        if (m && m[1]) {
            return m[1];
        }
        return null;
    }
    function compareChromeVersions($a, $b) {
        const a = $a.split(".").map((x) => parseInt(x));
        const b = $b.split(".").map((x) => parseInt(x));
        for (let i = 0; i < a.length; i++) {
            if (a[i] !== b[i]) {
                return a[i] < b[i] ? -1 : 1;
            }
        }
        return 0;
    }

    function ShortcutLink(props) {
        const cls = mergeClass("shortcut", props.class);
        const shortcut = props.shortcuts[props.commandName];
        let enteringShortcutInProgress = false;
        function startEnteringShortcut(node) {
            if (enteringShortcutInProgress) {
                return;
            }
            enteringShortcutInProgress = true;
            const initialText = node.textContent;
            node.textContent = "...⌨";
            function onKeyDown(e) {
                e.preventDefault();
                const ctrl = e.ctrlKey;
                const alt = e.altKey;
                const command = e.metaKey;
                const shift = e.shiftKey;
                let key = null;
                if (e.code.startsWith("Key")) {
                    key = e.code.substring(3);
                } else if (e.code.startsWith("Digit")) {
                    key = e.code.substring(5);
                }
                const shortcut = `${
                    ctrl ? "Ctrl+" : alt ? "Alt+" : command ? "Command+" : ""
                }${shift ? "Shift+" : ""}${key ? key : ""}`;
                node.textContent = shortcut;
                if ((ctrl || alt || command || shift) && key) {
                    removeListeners();
                    props.onSetShortcut(shortcut);
                    node.blur();
                    setTimeout(() => {
                        enteringShortcutInProgress = false;
                        node.classList.remove("shortcut--edit");
                        node.textContent = props.textTemplate(shortcut);
                    }, 500);
                }
            }
            function onBlur() {
                removeListeners();
                node.classList.remove("shortcut--edit");
                node.textContent = initialText;
                enteringShortcutInProgress = false;
            }
            function removeListeners() {
                window.removeEventListener("keydown", onKeyDown, true);
                window.removeEventListener("blur", onBlur, true);
            }
            window.addEventListener("keydown", onKeyDown, true);
            window.addEventListener("blur", onBlur, true);
            node.classList.add("shortcut--edit");
        }
        function onClick(e) {
            e.preventDefault();
            if (isFirefox()) {
                startEnteringShortcut(e.target);
                return;
            }
            chrome.tabs.create({
                url: `chrome://extensions/configureCommands#command-${chrome.runtime.id}-${props.commandName}`,
                active: true
            });
        }
        return m(
            "a",
            {class: cls, href: "#", onclick: onClick},
            props.textTemplate(shortcut)
        );
    }

    function Tab({isActive}, ...children) {
        const tabCls = {
            "tab-panel__tab": true,
            "tab-panel__tab--active": isActive
        };
        return m("div", {class: tabCls}, children);
    }

    function TabPanel(props) {
        const tabsNames = Object.keys(props.tabs);
        function isActiveTab(name, index) {
            return name == null ? index === 0 : name === props.activeTab;
        }
        const buttons = tabsNames.map((name, i) => {
            const btnCls = {
                "tab-panel__button": true,
                "tab-panel__button--active": isActiveTab(name, i)
            };
            return m(
                Button,
                {class: btnCls, onclick: () => props.onSwitchTab(name)},
                props.tabLabels[name]
            );
        });
        const tabs = tabsNames.map((name, i) =>
            m(Tab, {isActive: isActiveTab(name, i)}, props.tabs[name])
        );
        return m(
            "div",
            {class: "tab-panel"},
            m("div", {class: "tab-panel__buttons"}, buttons),
            m("div", {class: "tab-panel__tabs"}, tabs)
        );
    }

    function TextList(props) {
        const context = getComponentContext();
        context.store.indices = context.store.indices || new WeakMap();
        function onTextChange(e) {
            const index = context.store.indices.get(e.target);
            const values = props.values.slice();
            const value = e.target.value.trim();
            if (values.indexOf(value) >= 0) {
                return;
            }
            if (!value) {
                values.splice(index, 1);
            } else if (index === values.length) {
                values.push(value);
            } else {
                values.splice(index, 1, value);
            }
            props.onChange(values);
        }
        function createTextBox(text, index) {
            const saveIndex = (node) => context.store.indices.set(node, index);
            return m(TextBox, {
                class: "text-list__textbox",
                value: text,
                attached: saveIndex,
                updated: saveIndex,
                placeholder: props.placeholder
            });
        }
        let shouldFocus = false;
        const node = context.node;
        const prevProps = context.prev ? context.prev.props : null;
        if (
            node &&
            props.isFocused &&
            (!prevProps ||
                !prevProps.isFocused ||
                prevProps.values.length < props.values.length)
        ) {
            focusLastNode();
        }
        function didMount(node) {
            context.store.node = node;
            if (props.isFocused) {
                focusLastNode();
            }
        }
        function focusLastNode() {
            const node = context.store.node;
            shouldFocus = true;
            requestAnimationFrame(() => {
                const inputs = node.querySelectorAll(".text-list__textbox");
                const last = inputs.item(inputs.length - 1);
                last.focus();
            });
        }
        return m(VirtualScroll, {
            root: m("div", {
                class: ["text-list", props.class],
                onchange: onTextChange,
                attached: didMount
            }),
            items: props.values
                .map(createTextBox)
                .concat(createTextBox("", props.values.length)),
            scrollToIndex: shouldFocus ? props.values.length : -1
        });
    }

    function getLocalMessage(messageName) {
        return chrome.i18n.getMessage(messageName);
    }
    function getUILanguage() {
        return chrome.i18n.getUILanguage();
    }

    function parseTime($time) {
        const parts = $time.split(":").slice(0, 2);
        const lowercased = $time.trim().toLowerCase();
        const isAM = lowercased.endsWith("am") || lowercased.endsWith("a.m.");
        const isPM = lowercased.endsWith("pm") || lowercased.endsWith("p.m.");
        let hours = parts.length > 0 ? parseInt(parts[0]) : 0;
        if (isNaN(hours) || hours > 23) {
            hours = 0;
        }
        if (isAM && hours === 12) {
            hours = 0;
        }
        if (isPM && hours < 12) {
            hours += 12;
        }
        let minutes = parts.length > 1 ? parseInt(parts[1]) : 0;
        if (isNaN(minutes) || minutes > 59) {
            minutes = 0;
        }
        return [hours, minutes];
    }
    function getDuration(time) {
        let duration = 0;
        if (time.seconds) {
            duration += time.seconds * 1000;
        }
        if (time.minutes) {
            duration += time.minutes * 60 * 1000;
        }
        if (time.hours) {
            duration += time.hours * 60 * 60 * 1000;
        }
        if (time.days) {
            duration += time.days * 24 * 60 * 60 * 1000;
        }
        return duration;
    }
    function getSunsetSunriseUTCTime(date, latitude, longitude) {
        const dec31 = new Date(date.getUTCFullYear(), 0, 0);
        const oneDay = getDuration({days: 1});
        const dayOfYear = Math.floor((Number(date) - Number(dec31)) / oneDay);
        const zenith = 90.83333333333333;
        const D2R = Math.PI / 180;
        const R2D = 180 / Math.PI;
        const lnHour = longitude / 15;
        function getTime(isSunrise) {
            const t = dayOfYear + ((isSunrise ? 6 : 18) - lnHour) / 24;
            const M = 0.9856 * t - 3.289;
            let L =
                M +
                1.916 * Math.sin(M * D2R) +
                0.02 * Math.sin(2 * M * D2R) +
                282.634;
            if (L > 360) {
                L = L - 360;
            } else if (L < 0) {
                L = L + 360;
            }
            let RA = R2D * Math.atan(0.91764 * Math.tan(L * D2R));
            if (RA > 360) {
                RA = RA - 360;
            } else if (RA < 0) {
                RA = RA + 360;
            }
            const Lquadrant = Math.floor(L / 90) * 90;
            const RAquadrant = Math.floor(RA / 90) * 90;
            RA = RA + (Lquadrant - RAquadrant);
            RA = RA / 15;
            const sinDec = 0.39782 * Math.sin(L * D2R);
            const cosDec = Math.cos(Math.asin(sinDec));
            const cosH =
                (Math.cos(zenith * D2R) - sinDec * Math.sin(latitude * D2R)) /
                (cosDec * Math.cos(latitude * D2R));
            if (cosH > 1) {
                return {
                    alwaysDay: false,
                    alwaysNight: true,
                    time: 0
                };
            } else if (cosH < -1) {
                return {
                    alwaysDay: true,
                    alwaysNight: false,
                    time: 0
                };
            }
            const H =
                (isSunrise
                    ? 360 - R2D * Math.acos(cosH)
                    : R2D * Math.acos(cosH)) / 15;
            const T = H + RA - 0.06571 * t - 6.622;
            let UT = T - lnHour;
            if (UT > 24) {
                UT = UT - 24;
            } else if (UT < 0) {
                UT = UT + 24;
            }
            return {
                alwaysDay: false,
                alwaysNight: false,
                time: UT * getDuration({hours: 1})
            };
        }
        const sunriseTime = getTime(true);
        const sunsetTime = getTime(false);
        if (sunriseTime.alwaysDay || sunsetTime.alwaysDay) {
            return {
                alwaysDay: true
            };
        } else if (sunriseTime.alwaysNight || sunsetTime.alwaysNight) {
            return {
                alwaysNight: true
            };
        }
        return {
            sunriseTime: sunriseTime.time,
            sunsetTime: sunsetTime.time
        };
    }
    function isNightAtLocation(date, latitude, longitude) {
        const time = getSunsetSunriseUTCTime(date, latitude, longitude);
        if (time.alwaysDay) {
            return false;
        } else if (time.alwaysNight) {
            return true;
        }
        const sunriseTime = time.sunriseTime;
        const sunsetTime = time.sunsetTime;
        const currentTime =
            date.getUTCHours() * getDuration({hours: 1}) +
            date.getUTCMinutes() * getDuration({minutes: 1}) +
            date.getUTCSeconds() * getDuration({seconds: 1});
        if (sunsetTime > sunriseTime) {
            return currentTime > sunsetTime || currentTime < sunriseTime;
        } else {
            return currentTime > sunsetTime && currentTime < sunriseTime;
        }
    }

    const is12H = new Date().toLocaleTimeString(getUILanguage()).endsWith("M");
    function toLocaleTime($time) {
        const [hours, minutes] = parseTime($time);
        const mm = `${minutes < 10 ? "0" : ""}${minutes}`;
        if (is12H) {
            const h = hours === 0 ? "12" : hours > 12 ? hours - 12 : hours;
            return `${h}:${mm}${hours < 12 ? "AM" : "PM"}`;
        }
        return `${hours}:${mm}`;
    }
    function to24HTime($time) {
        const [hours, minutes] = parseTime($time);
        const mm = `${minutes < 10 ? "0" : ""}${minutes}`;
        return `${hours}:${mm}`;
    }
    function TimeRangePicker(props) {
        function onStartTimeChange($startTime) {
            props.onChange([to24HTime($startTime), props.endTime]);
        }
        function onEndTimeChange($endTime) {
            props.onChange([props.startTime, to24HTime($endTime)]);
        }
        function setStartTime(node) {
            node.value = toLocaleTime(props.startTime);
        }
        function setEndTime(node) {
            node.value = toLocaleTime(props.endTime);
        }
        return m(
            "span",
            {class: "time-range-picker"},
            m(TextBox, {
                class:
                    "time-range-picker__input time-range-picker__input--start",
                placeholder: toLocaleTime("18:00"),
                attached: setStartTime,
                updated: setStartTime,
                onchange: (e) => onStartTimeChange(e.target.value),
                onkeypress: (e) => {
                    if (e.key === "Enter") {
                        const input = e.target;
                        input.blur();
                        onStartTimeChange(input.value);
                    }
                }
            }),
            m(TextBox, {
                class: "time-range-picker__input time-range-picker__input--end",
                placeholder: toLocaleTime("9:00"),
                attached: setEndTime,
                updated: setEndTime,
                onchange: (e) => onEndTimeChange(e.target.value),
                onkeypress: (e) => {
                    if (e.key === "Enter") {
                        const input = e.target;
                        input.blur();
                        onEndTimeChange(input.value);
                    }
                }
            })
        );
    }

    function Toggle(props) {
        const {checked, onChange} = props;
        const cls = ["toggle", checked ? "toggle--checked" : null, props.class];
        const clsOn = {
            "toggle__btn": true,
            "toggle__on": true,
            "toggle__btn--active": checked
        };
        const clsOff = {
            "toggle__btn": true,
            "toggle__off": true,
            "toggle__btn--active": !checked
        };
        return m(
            "span",
            {class: cls},
            m(
                "span",
                {
                    class: clsOn,
                    onclick: onChange ? () => !checked && onChange(true) : null
                },
                props.labelOn
            ),
            m(
                "span",
                {
                    class: clsOff,
                    onclick: onChange ? () => checked && onChange(false) : null
                },
                props.labelOff
            )
        );
    }

    function Track(props) {
        const valueStyle = {width: `${props.value * 100}%`};
        const isClickable = props.onChange != null;
        function onMouseDown(e) {
            const targetNode = e.currentTarget;
            const valueNode = targetNode.firstElementChild;
            targetNode.classList.add("track--active");
            function getValue(clientX) {
                const rect = targetNode.getBoundingClientRect();
                return (clientX - rect.left) / rect.width;
            }
            function setWidth(value) {
                valueNode.style.width = `${value * 100}%`;
            }
            function onMouseMove(e) {
                const value = getValue(e.clientX);
                setWidth(value);
            }
            function onMouseUp(e) {
                const value = getValue(e.clientX);
                props.onChange(value);
                cleanup();
            }
            function onKeyPress(e) {
                if (e.key === "Escape") {
                    setWidth(props.value);
                    cleanup();
                }
            }
            function cleanup() {
                window.removeEventListener("mousemove", onMouseMove);
                window.removeEventListener("mouseup", onMouseUp);
                window.removeEventListener("keypress", onKeyPress);
                targetNode.classList.remove("track--active");
            }
            window.addEventListener("mousemove", onMouseMove);
            window.addEventListener("mouseup", onMouseUp);
            window.addEventListener("keypress", onKeyPress);
            const value = getValue(e.clientX);
            setWidth(value);
        }
        return m(
            "span",
            {
                class: {
                    "track": true,
                    "track--clickable": Boolean(props.onChange)
                },
                onmousedown: isClickable ? onMouseDown : null
            },
            m("span", {class: "track__value", style: valueStyle}),
            m("label", {class: "track__label"}, props.label)
        );
    }

    function UpDown(props) {
        const buttonDownCls = {
            "updown__button": true,
            "updown__button--disabled": props.value === props.min
        };
        const buttonUpCls = {
            "updown__button": true,
            "updown__button--disabled": props.value === props.max
        };
        function normalize(x) {
            const s = Math.round(x / props.step) * props.step;
            const exp = Math.floor(Math.log10(props.step));
            if (exp >= 0) {
                const m = Math.pow(10, exp);
                return Math.round(s / m) * m;
            } else {
                const m = Math.pow(10, -exp);
                return Math.round(s * m) / m;
            }
        }
        function clamp(x) {
            return Math.max(props.min, Math.min(props.max, x));
        }
        function onButtonDownClick() {
            props.onChange(clamp(normalize(props.value - props.step)));
        }
        function onButtonUpClick() {
            props.onChange(clamp(normalize(props.value + props.step)));
        }
        function onTrackValueChange(trackValue) {
            props.onChange(
                clamp(
                    normalize(trackValue * (props.max - props.min) + props.min)
                )
            );
        }
        const trackValue = (props.value - props.min) / (props.max - props.min);
        const valueText =
            props.value === props.default
                ? getLocalMessage("off").toLocaleLowerCase()
                : props.value > props.default
                ? `+${normalize(props.value - props.default)}`
                : `-${normalize(props.default - props.value)}`;
        return m(
            "div",
            {class: "updown"},
            m(
                "div",
                {class: "updown__line"},
                m(
                    Button,
                    {class: buttonDownCls, onclick: onButtonDownClick},
                    m("span", {class: "updown__icon updown__icon-down"})
                ),
                m(Track, {
                    value: trackValue,
                    label: props.name,
                    onChange: onTrackValueChange
                }),
                m(
                    Button,
                    {class: buttonUpCls, onclick: onButtonUpClick},
                    m("span", {class: "updown__icon updown__icon-up"})
                )
            ),
            m("label", {class: "updown__value-text"}, valueText)
        );
    }

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
    function isURLEnabled(url, userSettings, {isProtected, isInDarkList}) {
        if (isProtected) {
            return false;
        }
        const isURLInUserList = isURLInList(url, userSettings.siteList);
        if (userSettings.applyToListedOnly) {
            return isURLInUserList;
        }
        return !isInDarkList && !isURLInUserList;
    }

    function CustomSettingsToggle({data, tab, actions}) {
        const host = getURLHost(tab.url || "");
        const isCustom = data.settings.customThemes.some(({url}) =>
            isURLInList(tab.url, url)
        );
        const urlText = host
            ? host
                  .split(".")
                  .reduce(
                      (elements, part, i) =>
                          elements.concat(
                              m("wbr", null),
                              `${i > 0 ? "." : ""}${part}`
                          ),
                      []
                  )
            : "current site";
        return m(
            Button,
            {
                class: {
                    "custom-settings-toggle": true,
                    "custom-settings-toggle--checked": isCustom,
                    "custom-settings-toggle--disabled":
                        tab.isProtected ||
                        (tab.isInDarkList && !data.settings.applyToListedOnly)
                },
                onclick: (e) => {
                    if (isCustom) {
                        const filtered = data.settings.customThemes.filter(
                            ({url}) => !isURLInList(tab.url, url)
                        );
                        actions.changeSettings({customThemes: filtered});
                    } else {
                        const extended = data.settings.customThemes.concat({
                            url: [host],
                            theme: {...data.settings.theme}
                        });
                        actions.changeSettings({customThemes: extended});
                        e.currentTarget.classList.add(
                            "custom-settings-toggle--checked"
                        );
                    }
                }
            },
            m(
                "span",
                {class: "custom-settings-toggle__wrapper"},
                getLocalMessage("only_for"),
                " ",
                m("span", {class: "custom-settings-toggle__url"}, urlText)
            )
        );
    }

    function ModeToggle({mode, onChange}) {
        return m(
            "div",
            {class: "mode-toggle"},
            m(
                "div",
                {class: "mode-toggle__line"},
                m(
                    Button,
                    {
                        class: {"mode-toggle__button--active": mode === 1},
                        onclick: () => onChange(1)
                    },
                    m("span", {class: "icon icon--dark-mode"})
                ),
                m(Toggle, {
                    checked: mode === 1,
                    labelOn: getLocalMessage("dark"),
                    labelOff: getLocalMessage("light"),
                    onChange: (checked) => onChange(checked ? 1 : 0)
                }),
                m(
                    Button,
                    {
                        class: {"mode-toggle__button--active": mode === 0},
                        onclick: () => onChange(0)
                    },
                    m("span", {class: "icon icon--light-mode"})
                )
            ),
            m("label", {class: "mode-toggle__label"}, getLocalMessage("mode"))
        );
    }

    function FilterSettings({data, actions, tab}) {
        const custom = data.settings.customThemes.find(({url}) =>
            isURLInList(tab.url, url)
        );
        const filterConfig = custom ? custom.theme : data.settings.theme;
        function setConfig(config) {
            if (custom) {
                custom.theme = {...custom.theme, ...config};
                actions.changeSettings({
                    customThemes: data.settings.customThemes
                });
            } else {
                actions.setTheme(config);
            }
        }
        const brightness = m(UpDown, {
            value: filterConfig.brightness,
            min: 50,
            max: 150,
            step: 5,
            default: 100,
            name: getLocalMessage("brightness"),
            onChange: (value) => setConfig({brightness: value})
        });
        const contrast = m(UpDown, {
            value: filterConfig.contrast,
            min: 50,
            max: 150,
            step: 5,
            default: 100,
            name: getLocalMessage("contrast"),
            onChange: (value) => setConfig({contrast: value})
        });
        const grayscale = m(UpDown, {
            value: filterConfig.grayscale,
            min: 0,
            max: 100,
            step: 5,
            default: 0,
            name: getLocalMessage("grayscale"),
            onChange: (value) => setConfig({grayscale: value})
        });
        const sepia = m(UpDown, {
            value: filterConfig.sepia,
            min: 0,
            max: 100,
            step: 5,
            default: 0,
            name: getLocalMessage("sepia"),
            onChange: (value) => setConfig({sepia: value})
        });
        return m(
            "section",
            {class: "filter-settings"},
            m(ModeToggle, {
                mode: filterConfig.mode,
                onChange: (mode) => setConfig({mode})
            }),
            brightness,
            contrast,
            sepia,
            grayscale,
            m(CustomSettingsToggle, {data: data, tab: tab, actions: actions})
        );
    }

    function CheckmarkIcon({isEnabled}) {
        return m(
            "svg",
            {viewBox: "0 0 8 8"},
            m("path", {
                d: isEnabled
                    ? "M1,4 l2,2 l4,-4 v1 l-4,4 l-2,-2 Z"
                    : "M2,2 l4,4 v1 l-4,-4 Z M2,6 l4,-4 v1 l-4,4 Z"
            })
        );
    }

    function SiteToggleButton({data, tab, actions}) {
        const toggleHasEffect =
            data.isEnabled &&
            !tab.isProtected &&
            (data.settings.applyToListedOnly || !tab.isInDarkList);
        const isSiteEnabled = isURLEnabled(tab.url, data.settings, tab);
        const host = getURLHost(tab.url || "");
        const urlText = host
            ? host
                  .split(".")
                  .reduce(
                      (elements, part, i) =>
                          elements.concat(
                              m("wbr", null),
                              `${i > 0 ? "." : ""}${part}`
                          ),
                      []
                  )
            : "current site";
        return m(
            Button,
            {
                class: {
                    "site-toggle": true,
                    "site-toggle--active": isSiteEnabled,
                    "site-toggle--disabled": !toggleHasEffect
                },
                onclick: () => actions.toggleSitePattern(host)
            },
            m(
                "span",
                {class: "site-toggle__mark"},
                m(CheckmarkIcon, {isEnabled: isSiteEnabled})
            ),
            " ",
            m("span", {class: "site-toggle__url"}, urlText)
        );
    }

    function MoreToggleSettings({data, actions, isExpanded, onClose}) {
        const isSystemAutomation = data.settings.automation === "system";
        const locationSettings = data.settings.location;
        const values = {
            latitude: {
                min: -90,
                max: 90
            },
            longitude: {
                min: -180,
                max: 180
            }
        };
        function getLocationString(location) {
            if (location == null) {
                return "";
            }
            return `${location}°`;
        }
        function locationChanged(inputElement, newValue, type) {
            if (newValue.trim() === "") {
                inputElement.value = "";
                actions.changeSettings({
                    location: {
                        ...locationSettings,
                        [type]: null
                    }
                });
                return;
            }
            const min = values[type].min;
            const max = values[type].max;
            newValue = newValue.replace(",", ".").replace("°", "");
            let num = Number(newValue);
            if (isNaN(num)) {
                num = 0;
            } else if (num > max) {
                num = max;
            } else if (num < min) {
                num = min;
            }
            inputElement.value = getLocationString(num);
            actions.changeSettings({
                location: {
                    ...locationSettings,
                    [type]: num
                }
            });
        }
        return m(
            "div",
            {
                class: {
                    "header__app-toggle__more-settings": true,
                    "header__app-toggle__more-settings--expanded": isExpanded
                }
            },
            m(
                "div",
                {class: "header__app-toggle__more-settings__top"},
                m(
                    "span",
                    {class: "header__app-toggle__more-settings__top__text"},
                    getLocalMessage("automation")
                ),
                m(
                    "span",
                    {
                        class: "header__app-toggle__more-settings__top__close",
                        role: "button",
                        onclick: onClose
                    },
                    "\u2715"
                )
            ),
            m(
                "div",
                {class: "header__app-toggle__more-settings__content"},
                m(
                    "div",
                    {class: "header__app-toggle__more-settings__line"},
                    m(CheckBox, {
                        checked: data.settings.automation === "time",
                        onchange: (e) =>
                            actions.changeSettings({
                                automation: e.target.checked ? "time" : ""
                            })
                    }),
                    m(TimeRangePicker, {
                        startTime: data.settings.time.activation,
                        endTime: data.settings.time.deactivation,
                        onChange: ([start, end]) =>
                            actions.changeSettings({
                                time: {activation: start, deactivation: end}
                            })
                    })
                ),
                m(
                    "p",
                    {class: "header__app-toggle__more-settings__description"},
                    getLocalMessage("set_active_hours")
                ),
                m(
                    "div",
                    {
                        class:
                            "header__app-toggle__more-settings__line header__app-toggle__more-settings__location"
                    },
                    m(CheckBox, {
                        checked: data.settings.automation === "location",
                        onchange: (e) =>
                            actions.changeSettings({
                                automation: e.target.checked ? "location" : ""
                            })
                    }),
                    m(TextBox, {
                        class:
                            "header__app-toggle__more-settings__location__latitude",
                        placeholder: getLocalMessage("latitude"),
                        onchange: (e) =>
                            locationChanged(
                                e.target,
                                e.target.value,
                                "latitude"
                            ),
                        attached: (node) =>
                            (node.value = getLocationString(
                                locationSettings.latitude
                            )),
                        onkeypress: (e) => {
                            if (e.key === "Enter") {
                                e.target.blur();
                            }
                        }
                    }),
                    m(TextBox, {
                        class:
                            "header__app-toggle__more-settings__location__longitude",
                        placeholder: getLocalMessage("longitude"),
                        onchange: (e) =>
                            locationChanged(
                                e.target,
                                e.target.value,
                                "longitude"
                            ),
                        attached: (node) =>
                            (node.value = getLocationString(
                                locationSettings.longitude
                            )),
                        onkeypress: (e) => {
                            if (e.key === "Enter") {
                                e.target.blur();
                            }
                        }
                    })
                ),
                m(
                    "p",
                    {
                        class:
                            "header__app-toggle__more-settings__location-description"
                    },
                    getLocalMessage("set_location")
                ),
                m(
                    "div",
                    {
                        class: [
                            "header__app-toggle__more-settings__line",
                            "header__app-toggle__more-settings__system-dark-mode"
                        ]
                    },
                    m(CheckBox, {
                        class:
                            "header__app-toggle__more-settings__system-dark-mode__checkbox",
                        checked: isSystemAutomation,
                        onchange: (e) =>
                            actions.changeSettings({
                                automation: e.target.checked ? "system" : ""
                            })
                    }),
                    m(
                        Button,
                        {
                            class: {
                                "header__app-toggle__more-settings__system-dark-mode__button": true,
                                "header__app-toggle__more-settings__system-dark-mode__button--active": isSystemAutomation
                            },
                            onclick: () =>
                                actions.changeSettings({
                                    automation: isSystemAutomation
                                        ? ""
                                        : "system"
                                })
                        },
                        getLocalMessage("system_dark_mode")
                    )
                ),
                m(
                    "p",
                    {class: "header__app-toggle__more-settings__description"},
                    getLocalMessage("system_dark_mode_description")
                )
            )
        );
    }

    function WatchIcon({hours, minutes}) {
        const cx = 8;
        const cy = 8;
        const lh = 5;
        const lm = 7;
        const ah =
            (((hours > 11 ? hours - 12 : hours) + minutes / 60) / 12) *
            Math.PI *
            2;
        const am = (minutes / 60) * Math.PI * 2;
        const hx = cx + lh * Math.sin(ah);
        const hy = cy - lh * Math.cos(ah);
        const mx = cx + lm * Math.sin(am);
        const my = cy - lm * Math.cos(am);
        return m(
            "svg",
            {viewBox: "0 0 16 16"},
            m("line", {
                "stroke": "white",
                "stroke-width": "2",
                "x1": cx,
                "y1": cy,
                "x2": hx,
                "y2": hy
            }),
            m("line", {
                "stroke": "white",
                "stroke-width": "1.5",
                "x1": cx,
                "y1": cy,
                "x2": mx,
                "y2": my
            })
        );
    }

    function SunMoonIcon({date, latitude, longitude}) {
        if (latitude == null || longitude == null) {
            return m(
                "svg",
                {viewBox: "0 0 16 16"},
                m(
                    "text",
                    {
                        "fill": "white",
                        "font-size": "16",
                        "font-weight": "bold",
                        "text-anchor": "middle",
                        "x": "8",
                        "y": "14"
                    },
                    "?"
                )
            );
        }
        if (isNightAtLocation(date, latitude, longitude)) {
            return m(
                "svg",
                {viewBox: "0 0 16 16"},
                m("path", {
                    fill: "white",
                    stroke: "none",
                    d: "M 6 3 Q 10 8 6 13 Q 12 13 12 8 Q 12 3 6 3"
                })
            );
        }
        return m(
            "svg",
            {viewBox: "0 0 16 16"},
            m("circle", {
                fill: "white",
                stroke: "none",
                cx: "8",
                cy: "8",
                r: "3"
            }),
            m(
                "g",
                {
                    "fill": "none",
                    "stroke": "white",
                    "stroke-linecap": "round",
                    "stroke-width": "1.5"
                },
                Array.from({length: 8}).map((_, i) => {
                    const cx = 8;
                    const cy = 8;
                    const angle = (i * Math.PI) / 4 + Math.PI / 8;
                    const pt = [5, 6].map((l) => [
                        cx + l * Math.cos(angle),
                        cy + l * Math.sin(angle)
                    ]);
                    return m("line", {
                        x1: pt[0][0],
                        y1: pt[0][1],
                        x2: pt[1][0],
                        y2: pt[1][1]
                    });
                })
            )
        );
    }

    function SystemIcon() {
        return m(
            "svg",
            {viewBox: "0 0 16 16"},
            m("path", {
                fill: "white",
                stroke: "none",
                d:
                    "M3,3 h10 v7 h-3 v2 h1 v1 h-6 v-1 h1 v-2 h-3 z M4.5,4.5 v4 h7 v-4 z"
            })
        );
    }

    function multiline(...lines) {
        return lines.join("\n");
    }
    function Header({data, actions, tab, onMoreToggleSettingsClick}) {
        function toggleExtension(enabled) {
            actions.changeSettings({
                enabled,
                automation: ""
            });
        }
        const isAutomation = Boolean(data.settings.automation);
        const isTimeAutomation = data.settings.automation === "time";
        const isLocationAutomation = data.settings.automation === "location";
        const now = new Date();
        return m(
            "header",
            {class: "header"},
            m("img", {
                class: "header__logo",
                src: "../assets/images/darkreader-type.svg",
                alt: "Dark Reader"
            }),
            m(
                "div",
                {class: "header__control header__site-toggle"},
                m(SiteToggleButton, {data: data, tab: tab, actions: actions}),
                tab.isProtected
                    ? m(
                          "span",
                          {class: "header__site-toggle__unable-text"},
                          getLocalMessage("page_protected")
                      )
                    : tab.isInDarkList
                    ? m(
                          "span",
                          {class: "header__site-toggle__unable-text"},
                          getLocalMessage("page_in_dark_list")
                      )
                    : m(ShortcutLink, {
                          commandName: "addSite",
                          shortcuts: data.shortcuts,
                          textTemplate: (hotkey) =>
                              hotkey
                                  ? multiline(
                                        getLocalMessage("toggle_current_site"),
                                        hotkey
                                    )
                                  : getLocalMessage("setup_hotkey_toggle_site"),
                          onSetShortcut: (shortcut) =>
                              actions.setShortcut("addSite", shortcut)
                      })
            ),
            m(
                "div",
                {class: "header__control header__app-toggle"},
                m(Toggle, {
                    checked: data.isEnabled,
                    labelOn: getLocalMessage("on"),
                    labelOff: getLocalMessage("off"),
                    onChange: toggleExtension
                }),
                m(ShortcutLink, {
                    commandName: "toggle",
                    shortcuts: data.shortcuts,
                    textTemplate: (hotkey) =>
                        hotkey
                            ? multiline(
                                  getLocalMessage("toggle_extension"),
                                  hotkey
                              )
                            : getLocalMessage("setup_hotkey_toggle_extension"),
                    onSetShortcut: (shortcut) =>
                        actions.setShortcut("toggle", shortcut)
                }),
                m("span", {
                    class: "header__app-toggle__more-button",
                    onclick: onMoreToggleSettingsClick
                }),
                m(
                    "span",
                    {
                        class: {
                            "header__app-toggle__time": true,
                            "header__app-toggle__time--active": isAutomation
                        }
                    },
                    isTimeAutomation
                        ? m(WatchIcon, {
                              hours: now.getHours(),
                              minutes: now.getMinutes()
                          })
                        : isLocationAutomation
                        ? m(SunMoonIcon, {
                              date: now,
                              latitude: data.settings.location.latitude,
                              longitude: data.settings.location.longitude
                          })
                        : m(SystemIcon, null)
                )
            )
        );
    }

    function Loader({complete = false}) {
        const {state, setState} = useState({finished: false});
        return m(
            "div",
            {
                class: {
                    "loader": true,
                    "loader--complete": complete,
                    "loader--transition-end": state.finished
                },
                ontransitionend: () => setState({finished: true})
            },
            m(
                "label",
                {class: "loader__message"},
                getLocalMessage("loading_please_wait")
            )
        );
    }
    var Loader$1 = withState(Loader);

    var ThemeEngines = {
        cssFilter: "cssFilter",
        svgFilter: "svgFilter",
        staticTheme: "staticTheme",
        dynamicTheme: "dynamicTheme"
    };

    const engineNames = [
        [ThemeEngines.cssFilter, getLocalMessage("engine_filter")],
        [ThemeEngines.svgFilter, getLocalMessage("engine_filter_plus")],
        [ThemeEngines.staticTheme, getLocalMessage("engine_static")],
        [ThemeEngines.dynamicTheme, getLocalMessage("engine_dynamic")]
    ];
    function openCSSEditor() {
        chrome.windows.create({
            type: "panel",
            url: isFirefox()
                ? "../stylesheet-editor/index.html"
                : "ui/stylesheet-editor/index.html",
            width: 600,
            height: 600
        });
    }
    function EngineSwitch({engine, onChange}) {
        return m(
            "div",
            {class: "engine-switch"},
            m(MultiSwitch, {
                value: engineNames.find(([code]) => code === engine)[1],
                options: engineNames.map(([, name]) => name),
                onChange: (value) =>
                    onChange(engineNames.find(([, name]) => name === value)[0])
            }),
            m("span", {
                class: {
                    "engine-switch__css-edit-button": true,
                    "engine-switch__css-edit-button_active":
                        engine === ThemeEngines.staticTheme
                },
                onclick: openCSSEditor
            }),
            m(
                "label",
                {class: "engine-switch__description"},
                getLocalMessage("theme_generation_mode")
            )
        );
    }

    function FontSettings({config, fonts, onChange}) {
        return m(
            "section",
            {class: "font-settings"},
            m(
                "div",
                {class: "font-settings__font-select-container"},
                m(
                    "div",
                    {class: "font-settings__font-select-container__line"},
                    m(CheckBox, {
                        checked: config.useFont,
                        onchange: (e) => onChange({useFont: e.target.checked})
                    }),
                    m(Select$1, {
                        value: config.fontFamily,
                        onChange: (value) => onChange({fontFamily: value}),
                        options: fonts.reduce((map, font) => {
                            map[font] = m(
                                "div",
                                {style: {"font-family": font}},
                                font
                            );
                            return map;
                        }, {})
                    })
                ),
                m(
                    "label",
                    {class: "font-settings__font-select-container__label"},
                    getLocalMessage("select_font")
                )
            ),
            m(UpDown, {
                value: config.textStroke,
                min: 0,
                max: 1,
                step: 0.1,
                default: 0,
                name: getLocalMessage("text_stroke"),
                onChange: (value) => onChange({textStroke: value})
            })
        );
    }

    function compileMarkdown(markdown) {
        return markdown
            .split("**")
            .map((text, i) => (i % 2 ? m("strong", null, text) : text));
    }

    function MoreSettings({data, actions, tab}) {
        const custom = data.settings.customThemes.find(({url}) =>
            isURLInList(tab.url, url)
        );
        const filterConfig = custom ? custom.theme : data.settings.theme;
        function setConfig(config) {
            if (custom) {
                custom.theme = {...custom.theme, ...config};
                actions.changeSettings({
                    customThemes: data.settings.customThemes
                });
            } else {
                actions.setTheme(config);
            }
        }
        return m(
            "section",
            {class: "more-settings"},
            m(
                "div",
                {class: "more-settings__section"},
                m(FontSettings, {
                    config: filterConfig,
                    fonts: data.fonts,
                    onChange: setConfig
                })
            ),
            m(
                "div",
                {class: "more-settings__section"},
                isFirefox()
                    ? null
                    : m(
                          "p",
                          {class: "more-settings__description"},
                          compileMarkdown(
                              getLocalMessage("try_experimental_theme_engines")
                          )
                      ),
                m(EngineSwitch, {
                    engine: filterConfig.engine,
                    onChange: (engine) => setConfig({engine})
                })
            ),
            m(
                "div",
                {class: "more-settings__section"},
                m(CustomSettingsToggle, {
                    data: data,
                    tab: tab,
                    actions: actions
                }),
                tab.isProtected
                    ? m(
                          "p",
                          {
                              class:
                                  "more-settings__description more-settings__description--warning"
                          },
                          getLocalMessage("page_protected").replace("\n", " ")
                      )
                    : tab.isInDarkList
                    ? m(
                          "p",
                          {
                              class:
                                  "more-settings__description more-settings__description--warning"
                          },
                          getLocalMessage("page_in_dark_list").replace(
                              "\n",
                              " "
                          )
                      )
                    : m(
                          "p",
                          {class: "more-settings__description"},
                          getLocalMessage("only_for_description")
                      )
            ),
            isFirefox()
                ? m(
                      "div",
                      {class: "more-settings__section"},
                      m(Toggle, {
                          checked: data.settings.changeBrowserTheme,
                          labelOn: getLocalMessage("custom_browser_theme_on"),
                          labelOff: getLocalMessage("custom_browser_theme_off"),
                          onChange: (checked) =>
                              actions.changeSettings({
                                  changeBrowserTheme: checked
                              })
                      }),
                      m(
                          "p",
                          {class: "more-settings__description"},
                          getLocalMessage("change_browser_theme")
                      )
                  )
                : null
        );
    }

    const BLOG_URL = "https://darkreader.org/blog/";
    const DONATE_URL = "https://opencollective.com/darkreader";
    const GITHUB_URL = "https://github.com/darkreader/darkreader";
    const PRIVACY_URL = "https://darkreader.org/privacy/";
    const TWITTER_URL = "https://twitter.com/darkreaderapp";
    const helpLocales = ["be", "cs", "de", "en", "es", "fr", "it", "ru"];
    function getHelpURL() {
        const locale = getUILanguage();
        const matchLocale =
            helpLocales.find((hl) => hl === locale) ||
            helpLocales.find((hl) => locale.startsWith(hl)) ||
            "en";
        return `https://darkreader.org/help/${matchLocale}/`;
    }

    const NEWS_COUNT = 2;
    function News({news, expanded, onNewsOpen, onClose}) {
        return m(
            "div",
            {class: {"news": true, "news--expanded": expanded}},
            m(
                "div",
                {class: "news__header"},
                m(
                    "span",
                    {class: "news__header__text"},
                    getLocalMessage("news")
                ),
                m(
                    "span",
                    {class: "news__close", role: "button", onclick: onClose},
                    "\u2715"
                )
            ),
            m(
                "div",
                {class: "news__list"},
                news.slice(0, NEWS_COUNT).map((event) => {
                    const date = new Date(event.date);
                    let formattedDate;
                    try {
                        const locale = getUILanguage();
                        formattedDate = date.toLocaleDateString(locale, {
                            month: "short",
                            day: "numeric"
                        });
                    } catch (err) {
                        formattedDate = date.toISOString().substring(0, 10);
                    }
                    return m(
                        "div",
                        {
                            class: {
                                "news__event": true,
                                "news__event--unread": !event.read
                            }
                        },
                        m(
                            "a",
                            {
                                class: "news__event__link",
                                onclick: () => onNewsOpen(event),
                                href: event.url,
                                target: "_blank",
                                rel: "noopener noreferrer"
                            },
                            m(
                                "span",
                                {class: "news__event__date"},
                                formattedDate
                            ),
                            event.headline
                        )
                    );
                }),
                news.length <= NEWS_COUNT
                    ? null
                    : m(
                          "a",
                          {
                              class: {
                                  "news__read-more": true,
                                  "news__read-more--unread": news
                                      .slice(NEWS_COUNT)
                                      .find(({read}) => !read)
                              },
                              href: BLOG_URL,
                              target: "_blank",
                              onclick: () => onNewsOpen(...news),
                              rel: "noopener noreferrer"
                          },
                          getLocalMessage("read_more")
                      )
            )
        );
    }
    function NewsButton({active, count, onClick}) {
        return m(
            Button,
            {
                "class": {"news-button": true, "news-button--active": active},
                "href": "#news",
                "data-count": count > 0 && !active ? count : null,
                "onclick": (e) => {
                    e.currentTarget.blur();
                    onClick();
                }
            },
            getLocalMessage("news")
        );
    }

    function SiteListSettings({data, actions, isFocused}) {
        function isSiteUrlValid(value) {
            return /^([^\.\s]+?\.?)+$/.test(value);
        }
        return m(
            "section",
            {class: "site-list-settings"},
            m(Toggle, {
                class: "site-list-settings__toggle",
                checked: data.settings.applyToListedOnly,
                labelOn: getLocalMessage("invert_listed_only"),
                labelOff: getLocalMessage("not_invert_listed"),
                onChange: (value) =>
                    actions.changeSettings({applyToListedOnly: value})
            }),
            m(TextList, {
                class: "site-list-settings__text-list",
                placeholder: "google.com/maps",
                values: data.settings.siteList,
                isFocused: isFocused,
                onChange: (values) => {
                    if (values.every(isSiteUrlValid)) {
                        actions.changeSettings({siteList: values});
                    }
                }
            }),
            m(ShortcutLink, {
                class: "site-list-settings__shortcut",
                commandName: "addSite",
                shortcuts: data.shortcuts,
                textTemplate: (hotkey) =>
                    hotkey
                        ? `${getLocalMessage("add_site_to_list")}: ${hotkey}`
                        : getLocalMessage("setup_add_site_hotkey"),
                onSetShortcut: (shortcut) =>
                    actions.setShortcut("addSite", shortcut)
            })
        );
    }

    function openDevTools() {
        chrome.windows.create({
            type: "panel",
            url: isFirefox()
                ? "../devtools/index.html"
                : "ui/devtools/index.html",
            width: 600,
            height: 600
        });
    }
    function Body(props) {
        const {state, setState} = useState({
            activeTab: "Filter",
            newsOpen: false,
            moreToggleSettingsOpen: false
        });
        if (!props.data.isReady) {
            return m("body", null, m(Loader$1, {complete: false}));
        }
        const unreadNews = props.data.news.filter(({read}) => !read);
        function toggleNews() {
            if (state.newsOpen && unreadNews.length > 0) {
                props.actions.markNewsAsRead(unreadNews.map(({id}) => id));
            }
            setState({newsOpen: !state.newsOpen});
        }
        function onNewsOpen(...news) {
            const unread = news.filter(({read}) => !read);
            if (unread.length > 0) {
                props.actions.markNewsAsRead(unread.map(({id}) => id));
            }
        }
        let displayedNewsCount = unreadNews.length;
        if (unreadNews.length > 0 && !props.data.settings.notifyOfNews) {
            const latest = new Date(unreadNews[0].date);
            const today = new Date();
            const newsWereLongTimeAgo =
                latest.getTime() < today.getTime() - getDuration({days: 14});
            if (newsWereLongTimeAgo) {
                displayedNewsCount = 0;
            }
        }
        const globalThemeEngine = props.data.settings.theme.engine;
        const devtoolsData = props.data.devtools;
        const hasCustomFixes =
            (globalThemeEngine === ThemeEngines.dynamicTheme &&
                devtoolsData.hasCustomDynamicFixes) ||
            ([ThemeEngines.cssFilter, ThemeEngines.svgFilter].includes(
                globalThemeEngine
            ) &&
                devtoolsData.hasCustomFilterFixes) ||
            (globalThemeEngine === ThemeEngines.staticTheme &&
                devtoolsData.hasCustomStaticFixes);
        function toggleMoreToggleSettings() {
            setState({moreToggleSettingsOpen: !state.moreToggleSettingsOpen});
        }
        return m(
            "body",
            {class: {"ext-disabled": !props.data.isEnabled}},
            m(Loader$1, {complete: true}),
            m(Header, {
                data: props.data,
                tab: props.tab,
                actions: props.actions,
                onMoreToggleSettingsClick: toggleMoreToggleSettings
            }),
            m(TabPanel, {
                activeTab: state.activeTab,
                onSwitchTab: (tab) => setState({activeTab: tab}),
                tabs: {
                    "Filter": m(FilterSettings, {
                        data: props.data,
                        actions: props.actions,
                        tab: props.tab
                    }),
                    "Site list": m(SiteListSettings, {
                        data: props.data,
                        actions: props.actions,
                        isFocused: state.activeTab === "Site list"
                    }),
                    "More": m(MoreSettings, {
                        data: props.data,
                        actions: props.actions,
                        tab: props.tab
                    })
                },
                tabLabels: {
                    "Filter": getLocalMessage("filter"),
                    "Site list": getLocalMessage("site_list"),
                    "More": getLocalMessage("more")
                }
            }),
            m(
                "footer",
                null,
                m(
                    "div",
                    {class: "footer-links"},
                    m(
                        "a",
                        {
                            class: "footer-links__link",
                            href: PRIVACY_URL,
                            target: "_blank",
                            rel: "noopener noreferrer"
                        },
                        getLocalMessage("privacy")
                    ),
                    m(
                        "a",
                        {
                            class: "footer-links__link",
                            href: TWITTER_URL,
                            target: "_blank",
                            rel: "noopener noreferrer"
                        },
                        "Twitter"
                    ),
                    m(
                        "a",
                        {
                            class: "footer-links__link",
                            href: GITHUB_URL,
                            target: "_blank",
                            rel: "noopener noreferrer"
                        },
                        "GitHub"
                    ),
                    m(
                        "a",
                        {
                            class: "footer-links__link",
                            href: getHelpURL(),
                            target: "_blank",
                            rel: "noopener noreferrer"
                        },
                        getLocalMessage("help")
                    )
                ),
                m(
                    "div",
                    {class: "footer-buttons"},
                    m(
                        "a",
                        {
                            class: "donate-link",
                            href: DONATE_URL,
                            target: "_blank",
                            rel: "noopener noreferrer"
                        },
                        m(
                            "span",
                            {class: "donate-link__text"},
                            getLocalMessage("donate")
                        )
                    ),
                    m(NewsButton, {
                        active: state.newsOpen,
                        count: displayedNewsCount,
                        onClick: toggleNews
                    }),
                    m(
                        Button,
                        {
                            onclick: openDevTools,
                            class: {
                                "dev-tools-button": true,
                                "dev-tools-button--has-custom-fixes": hasCustomFixes
                            }
                        },
                        "\uD83D\uDEE0 ",
                        getLocalMessage("open_dev_tools")
                    )
                )
            ),
            m(News, {
                news: props.data.news,
                expanded: state.newsOpen,
                onNewsOpen: onNewsOpen,
                onClose: toggleNews
            }),
            m(MoreToggleSettings, {
                data: props.data,
                actions: props.actions,
                isExpanded: state.moreToggleSettingsOpen,
                onClose: toggleMoreToggleSettings
            })
        );
    }
    var Body$1 = compose(
        Body,
        withState,
        withForms
    );

    function popupHasBuiltInBorders() {
        const chromeVersion = getChromeVersion();
        return Boolean(
            chromeVersion &&
                !isVivaldi() &&
                !isYaBrowser() &&
                !isOpera() &&
                isWindows() &&
                compareChromeVersions(chromeVersion, "62.0.3167.0") < 0
        );
    }
    function popupHasBuiltInHorizontalBorders() {
        const chromeVersion = getChromeVersion();
        return Boolean(
            chromeVersion &&
                !isVivaldi() &&
                !isYaBrowser() &&
                !isEdge() &&
                !isOpera() &&
                ((isWindows() &&
                    compareChromeVersions(chromeVersion, "62.0.3167.0") >= 0 &&
                    compareChromeVersions(chromeVersion, "74.0.0.0") < 0) ||
                    (isMacOS() &&
                        compareChromeVersions(chromeVersion, "67.0.3373.0") >=
                            0 &&
                        compareChromeVersions(chromeVersion, "73.0.3661.0") <
                            0))
        );
    }
    function fixNotClosingPopupOnNavigation() {
        document.addEventListener("click", (e) => {
            if (e.defaultPrevented || e.button === 2) {
                return;
            }
            let target = e.target;
            while (target && !(target instanceof HTMLAnchorElement)) {
                target = target.parentElement;
            }
            if (target && target.hasAttribute("href")) {
                requestAnimationFrame(() => window.close());
            }
        });
    }

    function renderBody(data, tab, actions) {
        sync(
            document.body,
            m(Body$1, {data: data, tab: tab, actions: actions})
        );
    }
    async function start() {
        const connector = connect();
        window.addEventListener("unload", () => connector.disconnect());
        const [data, tab] = await Promise.all([
            connector.getData(),
            connector.getActiveTabInfo()
        ]);
        renderBody(data, tab, connector);
        connector.subscribeToChanges((data) =>
            renderBody(data, tab, connector)
        );
    }
    start();
    document.documentElement.classList.toggle("mobile", isMobile());
    document.documentElement.classList.toggle(
        "built-in-borders",
        popupHasBuiltInBorders()
    );
    document.documentElement.classList.toggle(
        "built-in-horizontal-borders",
        popupHasBuiltInHorizontalBorders()
    );
    if (isFirefox()) {
        fixNotClosingPopupOnNavigation();
    }
})();
