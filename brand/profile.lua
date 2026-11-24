-- Sidebar blocks built from `person` in _profile.yml (loaded for every page
-- through metadata-files):
--   {{< profile >}}        photo, frog mark and name, title (sidebar header)
--   {{< profile links >}}  contact links (sidebar footer, anchored to the
--                          bottom)

local function str(v)
  return v and pandoc.utils.stringify(v) or ""
end

local function esc(s)
  return (s:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub('"', "&quot;"))
end

local function logo_svg()
  local f = io.open(quarto.project.directory .. "/brand/logo/logo.svg")
  if not f then return "" end
  local svg = f:read("a"):gsub("%s+$", "")
  f:close()
  -- Decorative beside the name, which is the accessible text.
  return (svg:gsub("<title>.-</title>", ""):gsub(' role="img"', ' aria-hidden="true" focusable="false"'))
end

local function links_block(p)
  local items = {}
  for _, l in ipairs(p.links or {}) do
    local text, href = esc(str(l.text)), str(l.href)
    if href:match("^TODO") then
      items[#items + 1] = string.format('<li><span class="profile-todo" title="%s">%s</span></li>', esc(href), text)
    else
      items[#items + 1] = string.format('<li><a href="%s">%s</a></li>', esc(href), text)
    end
  end
  return pandoc.RawBlock("html", '<ul class="profile-links">' .. table.concat(items) .. "</ul>")
end

local function profile(args, _, meta)
  local p = meta.person
  if not p then return pandoc.Null() end
  if args[1] and str(args[1]) == "links" then return links_block(p) end

  local out = { '<div class="profile">' }

  local photo = str(p.photo)
  if photo ~= "" then
    -- Root-relative, so the photo resolves from pages in any folder.
    out[#out + 1] = string.format('<a class="profile-photo" href="/"><img src="/%s" alt="%s" width="96" height="96"></a>',
      esc(photo), esc(str(p["photo-alt"])))
  end

  out[#out + 1] = string.format('<p class="profile-name"><a href="/"><span class="profile-logo">%s</span>%s</a></p>',
    logo_svg(), esc(str(p.name)))

  -- Only the title here; department and institution are on the About page.
  if str(p.title) ~= "" then
    out[#out + 1] = '<p class="profile-role">' .. esc(str(p.title)) .. "</p>"
  end

  out[#out + 1] = "</div>"
  return pandoc.RawBlock("html", table.concat(out, "\n"))
end

return { ["profile"] = profile }
