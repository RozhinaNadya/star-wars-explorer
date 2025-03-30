# Star Wars Explorer

  <p align="center" width="100%"> 
    <img width="23%" src="https://github.com/user-attachments/assets/f2655601-2342-4301-baab-3ab8de90e1dd">
    <img width="23%" src="https://github.com/user-attachments/assets/77f7feac-23b2-4f00-bef1-94aeae9ce213">
    <img width="23%" src="https://github.com/user-attachments/assets/c5341dd4-3325-4358-afa8-068f03871362">
    <img width="23%" src="https://github.com/user-attachments/assets/5a0ddc99-444e-419f-8e87-b6c3283055b6">
  </p>

## App overview:
Showcase video :movie_camera: [[Link](https://drive.google.com/file/d/1V-KRpDyntNuhmI1qfjT5ZPpVJhqrDNcO/view?usp=sharing)]

Star Wars Explorer presents a list of characters and the films they appeared in. User can learn more about a character by clicking on the item with their name. Characters details are presented on modal view and contained Homeworld name, height, gender, birth year and the character name. User also can find a character by using search bar. 

## Comments about implementation:

### Caching
Resposible class is [CacheManager](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/Sources/CacheManager.swift)

CacheManager has get and set functions for CharactersData, HomeworldName and FilmTitles. Since in the CharactersData we can find Homeworld and Films as URLs, we need to manage their cache as well.

### API
Resposible class is [CharactersAPIService](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/Sources/CharactersAPIService.swift)

For following abstraction, flexibility, testability, and better code organization principles, the class uses ICharactersAPIService protocol. The class has "shared" property as a Singleton to use only one instance of CharactersAPIService across the app. We can decode our data from URLs here with checking if the cache of these URLs is existed. 

### MVVM

<img width="520" alt="Screenshot 2025-03-30 at 20 35 10" src="https://github.com/user-attachments/assets/5a377049-b9f2-4cd8-b2ca-9e54f79f1afd" />

The project has [models](https://github.com/RozhinaNadya/star-wars-explorer/tree/main/StarWarsExplorer/Models) for CharactersResponseData, Character, CharacterListItem and Detail. That helps for proper decoding and easy data using in views and viewModels.

[CharacterListViewModel](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/CharacterListViewModel.swift) for [CharactersListView](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/CharactersListView.swift) with a component [CharactersListItemView](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/Components/CharactersListItem/CharactersListItemView.swift)

[CharacterDetailsViewModel](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/Components/CharacterDetails/CharacterDetailsViewModel.swift) for [CharacterDetailsView](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/Components/CharacterDetails/CharacterDetailsView.swift) with a component [DetailView](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/Components/CharacterDetails/CharacterDetail/DetailView.swift)

### UI 
Since characters data has pagination the optimal way to present the list is LazyVGrid. It reduces memory usage, improves scroll performance and allows smooth dynamic loading of more data. CharactersListView has also view components (subviews) inside for more readability. 

CharacterDetailsView is presented in modal view with 0,4 fraction. Before showing the modal view, I make check if the presented content is updated (to do not show empty view).

### Logic
The main logic is in [CharacterListViewModel](https://github.com/RozhinaNadya/star-wars-explorer/blob/main/StarWarsExplorer/CharactersList/CharacterListViewModel.swift) class

Here I handle all conditions for the View rendering and also control characters fetching, fetching more characters when it's needed and searching. Before making a new API request to avoid duplicate fetches I check the fetchedPages set. That is specially helpfull for searching. Searching also has "debounce", to avoid many unnecessary calls during user fast typing.
