# Madden Draft board
What need to do?
I need a application wich will save players from Madden Draft Board
Why?
To make both board Horizontal and Vertical works ok.
I'll List every player I've interest.
Then I'll rank they in my board so, in the day of draft I'll have my own board.


## Tasks
- [] Enter on draft page and show players
- [] Dynamic columns size for Forms
- [] Review Project, components Keybinding and commands are confused

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

