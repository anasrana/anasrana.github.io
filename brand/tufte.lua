-- Tufte house style applied at render time, so pages need no special markup.
--   1. Acronyms (two or more capitals, e.g. MRC, RNA-seq, CNNs) become
--      <span class="acronym"> and are set in small caps by tufte.scss.
--   2. The tadpole sparkline closes the last paragraph of each page.
--      Turn it off for a page with `endmark: false` in its front matter.
--   3. A Markdown rule (***) becomes a centred tadpole section break.
--   4. A block quote that opens with a quotation mark hangs that mark
--      outside the text edge.

local tadpole

local function read_tadpole()
  local f = io.open(quarto.project.directory .. "/brand/logo/tadpole.svg")
  if not f then return nil end
  local svg = f:read("a"):gsub("%s+$", "")
  f:close()
  -- Decorative here: drop the title and hide it from screen readers.
  svg = svg:gsub("<title>.-</title>", ""):gsub(' role="img"', ' aria-hidden="true" focusable="false"')
  return svg
end

-- 1. Acronyms ---------------------------------------------------------------

-- Capitals that are part of a name rather than an acronym.
local not_acronyms = { ET = true } -- ET Book

local function split_acronyms(s)
  local out, pos = {}, 1
  while true do
    local a, b, caps = s:find("%f[%w](%u[%u%d]+)%f[^%u%d]", pos)
    if not a then break end
    local after = s:sub(b + 1, b + 1)
    local plural = after == "s" and not s:sub(b + 2, b + 2):match("%w")
    -- Skip words that continue in lower case (e.g. "PhD" is not matched, but "PDFs" is).
    if (after:match("%l") and not plural) or not_acronyms[caps] then
      pos = b + 1
    else
      if a > pos then out[#out + 1] = pandoc.Str(s:sub(pos, a - 1)) end
      out[#out + 1] = pandoc.Span(caps, { class = "acronym" })
      pos = b + 1
    end
  end
  if #out == 0 then return nil end
  if pos <= #s then out[#out + 1] = pandoc.Str(s:sub(pos)) end
  return out
end

local acronyms = {
  Str = function(el) return split_acronyms(el.text) end,
  -- Leave code, maths, links' URLs and raw markup alone (Str only); also leave
  -- text that is already small caps.
  SmallCaps = function(el) return el, false end,
}

-- 4. Hanging quotation marks -------------------------------------------------

-- An empty span with a negative margin pulls the opening mark into the gutter.
local hang = '<span class="hang-quote"></span>'

local function hang_first_quote(bq)
  local first = bq.content[1]
  if not first or (first.t ~= "Para" and first.t ~= "Plain") then return nil end
  local lead = first.content[1]
  local opens = lead and (lead.t == "Quoted"
    or (lead.t == "Str" and (lead.text:match("^“") or lead.text:match("^‘") or lead.text:match('^"'))))
  if not opens then return nil end
  first.content:insert(1, pandoc.RawInline("html", hang))
  return bq
end

-- 2 and 3. Tadpole marks ------------------------------------------------------

local function append_endmark(blocks)
  for i = #blocks, 1, -1 do
    local b = blocks[i]
    if b.t == "Para" or b.t == "Plain" then
      b.content:insert(pandoc.RawInline("html", '<span class="endmark">' .. tadpole .. "</span>"))
      return true
    elseif b.t == "BulletList" or b.t == "OrderedList" then
      return append_endmark(b.content[#b.content])
    elseif b.t == "Div" and (b.classes:includes("column-margin") or b.classes:includes("hidden")) then
      -- Margin content and Quarto's hidden metadata are not the end of the text.
    elseif b.t == "Div" or b.t == "BlockQuote" then
      return append_endmark(b.content)
    else
      return false
    end
  end
  return false
end

function Pandoc(doc)
  if not quarto.doc.is_format("html") then return doc end
  tadpole = read_tadpole()

  doc.blocks = doc.blocks:walk(acronyms)
  doc.blocks = doc.blocks:walk({ BlockQuote = hang_first_quote })

  if tadpole then
    doc.blocks = doc.blocks:walk({
      HorizontalRule = function()
        return pandoc.RawBlock("html", '<div class="section-break" role="separator">' .. tadpole .. "</div>")
      end,
    })
    if doc.meta.endmark ~= false then append_endmark(doc.blocks) end
  end
  return doc
end
