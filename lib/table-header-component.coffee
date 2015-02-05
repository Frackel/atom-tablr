React = require 'react-atom-fork'
{div} = require 'reactionary-atom-fork'

module.exports = React.createClass
  getInitialState: ->
    columnsWidths: []
    columnsAligns: []

  render: ->
    {parentView} = @props
    {table, columnsAligns, gutter, totalRows, absoluteColumnsWidths} = @state

    cells = []

    if table?
      width = @getTableWidth()
      for column,index in table.getColumns()
        classes = ['table-edit-header-cell']
        classes.push 'active-column' if parentView.isActiveColumn(index)

        if parentView.order is column.name
          classes.push 'order'

          if parentView.direction is 1
            classes.push 'ascending'
          else
            classes.push 'descending'

        editAction = div className: 'column-edit-action'
        resizeHandle = div className: 'column-resize-handle'

        cells.push div {
          key: "header-cell-#{index}"
          className: classes.join(' ')
          style:
            width: "#{parentView.getScreenColumnWidthAt(index)}px"
            left: "#{parentView.getScreenColumnOffsetAt(index)}px"
            'text-align': columnsAligns[index] ? 'left'
        }, column.name, editAction, resizeHandle

    cellsWrapper = div {
      className: 'table-edit-header-wrapper'
      style:
        width: "#{width}px"
    }, cells

    row = div className: 'table-edit-header-row', cellsWrapper

    content = [row]
    if gutter
      content.unshift div className: 'table-edit-header-filler', totalRows

    content.push div className: 'column-resize-ruler'

    div className: 'table-edit-header-content', content

  getTableWidth: ->
    lastIndex = Math.max(0, @state.totalColumns - 1)
    return 0 if lastIndex is 0

    @props.parentView.getScreenColumnOffsetAt(lastIndex) + @props.parentView.getScreenColumnWidthAt(lastIndex)
