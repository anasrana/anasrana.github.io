-- {{< profile >}}: the profile block at the top of the sidebar, built from
-- `person` in _profile.yml (loaded for every page through metadata-files).
-- Photo, frog mark and name, role, then the contact links.

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

local function profile(_, _, meta)
  local p = meta.person
  if not p then return pandoc.Null() end

  local out = { '<div class="profile">' }

  local photo = str(p.photo)
  if photo ~= "" then
    -- Root-relative, so the photo resolves from pages in any folder.
    out[#out + 1] = string.format('<a class="profile-photo" href="/"><img src="/%s" alt="%s" width="96" height="96"></a>',
      esc(photo), esc(str(p["photo-alt"])))
  end

  out[#out + 1] = string.format('<p class="profile-name"><a href="/"><span class="profile-logo">%s</span>%s</a></p>',
    logo_svg(), esc(str(p.name)))

  local role = {}
  for _, k in ipairs({ "title", "department", "institution" }) do
    if str(p[k]) ~= "" then role[#role + 1] = esc(str(p[k])) end
  end
  if #role > 0 then
    out[#out + 1] = '<p class="profile-role">' .. table.concat(role, "<br>") .. "</p>"
  end

  if p.links and #p.links > 0 then
    local links = {}
    for _, l in ipairs(p.links) do
      local text, href = esc(str(l.text)), str(l.href)
      if href:match("^TODO") then
        links[#links + 1] = string.format('<li><span class="profile-todo" title="%s">%s</span></li>', esc(href), text)
      else
        links[#links + 1] = string.format('<li><a href="%s">%s</a></li>', esc(href), text)
      end
    end
    out[#out + 1] = '<ul class="profile-links">' .. table.concat(links) .. "</ul>"
  end

  out[#out + 1] = "</div>"
  return pandoc.RawBlock("html", table.concat(out, "\n"))
end

return { ["profile"] = profile }
