# Madden Draft board
What need to do?
I need a application wich will save players from Madden Draft Board
Why?
To make both board Horizontal and Vertical works ok.
I'll List every player I've interest.
Then I'll rank they in my board so, in the day of draft I'll have my own board.


## Tasks
## Board Players
- [] Player List
  - [x] cursor
  - [] change rank

- [] Player details
  - [] Form
  - [] Save 
- [] Player list details
  - [] Show details player selected
  - [] Edit players details

- [-] List
  - [x] Navigation betwenn board and home
  - [x] Table players
  - [] Order by (rank, age, expected drafted)
  - [] Vertical board

## Done
- [x] Player boundary
- [x] Figure out why validation on object isn't working -- IS working, but not properly
- [x] Refactor core function to be more functional orriented
- [x] Combine and skills
- [x] Validations on change_player_rank
- [x] Refactor code -- be more functional
- [x] Show players data
- [x] List player rank by position
- [x] Mark player as drafted
- [x] Make board as Dynamic supervisor
- [x] Make top bar
- [x] Build bottom bar
- [x] Build Draft creation page
- [x] Rework shortcuts module
- [x] Refactor Text utils
- [x] Make a cursor module to control which field to fill
- [x] Refactor Form module - Build page dynamic
- [x] Keybinding to save form information
- [x] Send information to Board process
- [x] Figure out how forms are gonna be used, right now we have duplicate codes
- [x] DraftSupervisor returns boards created
  - to get the name for now we are gonna use 
  ```
    Registry.keys(MaddenDraft.BoardRegistry, pid(0,228,0))
  ```
- [x] Page for List of boards created
- [x] Make madden draft page
- [x] Cursor for home page select the draft
- [x] Enter on draft page and show players
  - [x] enter action to select draft
  - [x] home get board and players
  - [x] redirect to board page showing players in the board
- [x] Create form generically
- [x] Create player
    - [x] Form
    - [x] Cursor movement
    - [x] Text edit
    - [x] Binding creation
- [x] Review Project: views, components, keybinding and commands are confused
  - [x] Re think about the project, maybe some module has to change their names, modules taking a lot of responsibility
- [x] Tab changes in a global key (probabily n and N key)
- [x] Centralize pages, tabs names and form keys
- [x] Instead of atoms for pages and tabs, modules as with default functions (render, fields, tabs) this will erase every case to switch tabs
- [x] Re-organize modules and names
- [x] Player
    - [x] Save player

   

## Columns size
Right now columns for form page can only have a size of 12 
We need to create a way to make this columns customized


## Testing
Test OTP directly
```
$ iex -S mix
$ MaddenDraft.Boundary.DraftSupervisor.create_board('2022')
$ MaddenDraft.Boundary.BoardManager.lazy_players('2022')
$ MaddenDraft.Boundary.BoardManager.show('2022')
```

Creating on view
```
$ iex -S mix
$ Ratatouille.run MaddenDraft.View.App
$ MaddenDraft.Boundary.BoardManager.show("Madden")
```

or get from pid
```
$ Supervisor.which_children MaddenDraft.Boundary.DraftSupervisor
$ MaddenDraft.Boundary.BoardManager.show(pid(0,234,0))
```

## UI candidates
https://github.com/ndreynolds/ratatouille
https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html

