local Cell = {}
setmetatable(Cell, {
	__index = Cell,
	__call = function(...)
		return setmetatable({}, Cell)
	end,
})

function Cell:SetDefaults()
	self.minWidth = 0
	self.minHeight = 0
	self.prefWidth = 0
	self.prefHeight = 0
	self.maxWidth = 0
	self.maxHeight = 0
	self.spaceTop = 0
	self.spaceLeft = 0
	self.spaceBottom = 0
	self.spaceRight = 0
	self.padTop = 0
	self.padLeft = 0
	self.padBottom = 0
	self.padRight = 0
	self.fillX = 0
	self.fillY = 0
	self.align = FILL
	self.expandX = 0
	self.expandY = 0
	self.ignore = false
	self.colspan = 1
	self.uniformX = nil
	self.uniformY = nil
end
function Cell:Clear()
	self.minWidth = nil
	self.minHeight = nil
	self.prefWidth = nil
	self.prefHeight = nil
	self.maxWidth = nil
	self.maxHeight = nil
	self.spaceTop = nil
	self.spaceLeft = nil
	self.spaceBottom = nil
	self.spaceRight = nil
	self.padTop = nil
	self.padLeft = nil
	self.padBottom = nil
	self.padRight = nil
	self.fillX = nil
	self.fillY = nil
	self.align = nil
	self.expandX = nil
	self.expandY = nil
	self.ignore = nil
	self.colspan = nil
	self.uniformX = nil
	self.uniformY = nil
end

function Cell:Set(defaults)
	self.minWidth = defaults.minWidth
	self.minHeight = defaults.minHeight
	self.prefWidth = defaults.prefWidth
	self.prefHeight = defaults.prefHeight
	self.maxWidth = defaults.maxWidth
	self.maxHeight = defaults.maxHeight
	self.spaceTop = defaults.spaceTop
	self.spaceLeft = defaults.spaceLeft
	self.spaceBottom = defaults.spaceBottom
	self.spaceRight = defaults.spaceRight
	self.padTop = defaults.padTop
	self.padLeft = defaults.padLeft
	self.padBottom = defaults.padBottom
	self.padRight = defaults.padRight
	self.fillX = defaults.fillX
	self.fillY = defaults.fillY
	self.align = defaults.align
	self.expandX = defaults.expandX
	self.expandY = defaults.expandY
	self.ignore = defaults.ignore
	self.colspan = defaults.colspan
	self.uniformX = defaults.uniformX
	self.uniformY = defaults.uniformY
end

function Cell:Merge(cell)
	if (cell == null) then return end
	if (cell.minWidth ~= nil) then self.minWidth = cell.minWidth end
	if (cell.minHeight ~= nil) then self.minHeight = cell.minHeight end
	if (cell.prefWidth ~= nil) then self.prefWidth = cell.prefWidth end
	if (cell.prefHeight ~= nil) then self.prefHeight = cell.prefHeight end
	if (cell.maxWidth ~= nil) then self.maxWidth = cell.maxWidth end
	if (cell.maxHeight ~= nil) then self.maxHeight = cell.maxHeight end
	if (cell.spaceTop ~= nil) then self.spaceTop = cell.spaceTop end
	if (cell.spaceLeft ~= nil) then self.spaceLeft = cell.spaceLeft end
	if (cell.spaceBottom ~= nil) then self.spaceBottom = cell.spaceBottom end
	if (cell.spaceRight ~= nil) then self.spaceRight = cell.spaceRight end
	if (cell.padTop ~= nil) then self.padTop = cell.padTop end
	if (cell.padLeft ~= nil) then self.padLeft = cell.padLeft end
	if (cell.padBottom ~= nil) then self.padBottom = cell.padBottom end
	if (cell.padRight ~= nil) then self.padRight = cell.padRight end
	if (cell.fillX ~= nil) then self.fillX = cell.fillX end
	if (cell.fillY ~= nil) then self.fillY = cell.fillY end
	if (cell.align ~= nil) then self.align = cell.align end
	if (cell.expandX ~= nil) then self.expandX = cell.expandX end
	if (cell.expandY ~= nil) then self.expandY = cell.expandY end
	if (cell.ignore ~= nil) then self.ignore = cell.ignore end
	if (cell.colspan ~= nil) then self.colspan = cell.colspan end
	if (cell.uniformX ~= nil) then self.uniformX = cell.uniformX end
	if (cell.uniformY ~= nil) then self.uniformY = cell.uniformY end
end

local TABLE = {}

function TABLE:Init()
	self.cells = {}
	self.rowDefaults = Cell()

	self.columnCount = 0
	self.rowCount = 0
end

function TABLE:Add(comp)
	local cell = Cell()
	cell.comp = comp

	if #self.cells then
		local lastCell = self.cells[#self.cells]
		if not lastCell.endRow then
			cell.column = lastCell.column + lastCell.colspan
			cell.row = lastCell.row
		else
			cell.column = 0
			cell.row = lastCell.row + 1
		end
	else
		cell.column = 0
		cell.row = 0
	end

	table.insert(self.cells, cell)
	comp:SetParent(self)

	return cell
end

function TABLE:Row()
	if #self.cells > 0 then
		self:_EndRow()
	end

	self.rowDefaults = Cell()
	return self.rowDefaults
end
function TABLE:_EndRow()
	local rowColumns = 0

	for i=self.cells, 0, -1 do
		local cell = self.cells[i]
		if cell.endRow then break end

		rowColumns = rowColumns + cell.colspan
	end

	self.columnCount = math.max(self.columnCount, rowColumns)
	self.rowCount = self.rowCount + 1

	self.cells[#self.cells].endRow = true

	self:InvalidateLayout()
end

function TABLE:PerformLayout()
	self:LayoutTable(0, 0, self:GetWide(), self:GetTall())
end

function TABLE:LayoutTable(lx, ly, lw, lh)

end

vgui.Register("WTable", TABLE, "Panel")

if IsValid(WTABLEDEBUG) then WTABLEDEBUG:Remove() end
WTABLEDEBUG = vgui.Create("WTable")
WTABLEDEBUG:SetPos(0, 0)
WTABLEDEBUG:SetSize(512, 512)