---@meta _

---@class Node

---Snippet Node
---@param context string|table Context description
---@param nodes string|Node|table<Node> Nodes description
---@param opts string|table? Opts description
---@return Node
function s(context, nodes, opts) end

---Input Node
---@param pos integer Pos description
---@param static_text string? static_text description
---@param opts table? opts description
---@return Node
function i(pos, static_text, opts) end

---Format nodes
---@param str string Format string
---@param nodes table Snippet node or list of nodes
---@param opts table? Optional table
---@return Node|table<Node> # List of snippet nodes
function fmt(str, nodes, opts) end

---Format nodes alternative
---@param str string Format string
---@param nodes table Snippet node or list of nodes
---@param opts table? Optional table
---@return Node|table<Node> # List of snippet nodes
function fmta(str, nodes, opts) end

---Function Node
---@param fn function
---@param args? any|table
---@param opts? table
---@return Node
function f(fn, args, opts) end

---Choice Node
---@param pos integer
---@param choices Node|table<Node>
---@param opts? table
---@return Node
function c(pos, choices, opts) end

---Text Node
---@param static_text string|table<string>
---@param opts? table
---@return Node
function t(static_text, opts) end

---Context Snippet
---@param context string|integer|table
---@param nodes Node|table<Node>
---@param opts? table
function sn(context, nodes, opts) end

---Restore Node
---@param pos integer|string
---@param key string
---@param nodes? Node|table<Node>
---@param opts? table
function r(pos, key, nodes, opts) end

---Repeat a Node
---@param node_indx integer
---@return Node
function rep(node_indx) end

---Partial
---@param func function
---@param ... any
function p(func, ...) end
