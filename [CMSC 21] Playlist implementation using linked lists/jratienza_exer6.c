/*
Author: Jonas Atienza
Date Modified: Aug 06, 2022
Program Description: This program implements a music playlist using structures and files.
*/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define BUFFER_SIZE 4096 // Define a buffer size.

// Declare structs.
typedef struct song_tag {
    char *songTitle;
    char *songArtist;
    char *songAlbum;
    struct song_tag * nextSong_ ;
} song ;

typedef struct playlist_tag {
    char *playlistName;
    int songCount ;
    song * songHead ;
    struct playlist_tag * nextPlaylist_ ;
} playlist ;

// Declare function prototypes.
void saveData(playlist*);
void loadData(playlist**, int*);

int insertNewPlaylistNode(playlist**, playlist*);
void insertNewSongNode(playlist**, song*);

void fetchSongs(song*);
void availableSongsForDeletion(playlist*, int, song*);
void printPlaylists(playlist*);
void printPlaylistContents(playlist*, int);

void addPlaylist(playlist**, int*);
void addSongToPlaylist(playlist**, int*);
void removeSongFromPlaylist(playlist**, int*);
void viewAPlaylist(playlist*, int);
void viewAllData(playlist*, int);
void freeHeap(playlist**);

void noPlaylistsErr();
void invalidInputErr();
int blankInputErr();

int main(){
    int scanfRtn = 0, choice = 0, playlistCount = 0; // Declare and initialize variables.

    playlist *playlistHead = NULL; // Declare and initialize a head playlist node.
    
    loadData(&playlistHead, &playlistCount); // Load from file.

    while(1){ // Loop main menu until program exit.
        printf("[≡] ≡≡≡≡≡===---- MENU ----===≡≡≡≡≡ [≡]\n");
        printf(" ║                                  ║\n");
        printf(" ║  [1] Add Playlist                ║\n");
        printf(" ║  [2] Add Song to Playlist        ║\n");
        printf(" ║  [3] Remove Song from Playlist   ║\n");
        printf(" ║  [4] View a Playlist             ║\n");
        printf(" ║  [5] View All Data               ║\n");
        printf(" ║  [6] Exit                        ║\n");
        printf(" ║                                  ║\n");
        printf(" ╚══════════════════════════════════╝\n\n");

        // Take user input
        printf(" ╔══════════════════|\n");
        printf("[≡] Enter choice: "); scanfRtn = scanf("%d", &choice); // Get the returned value of scanf for input validation purposes; avoids infinite loop when a char is entered.
        printf(" ╚══════════════════|\n\n");

        printf("---------------------------------------\n\n");

        if(scanfRtn == 0) invalidInputErr(); // If scanf returns 0 = format validation is not met.
        else if (choice >= 1 || choice <= 6){ 
            switch (choice){
                case 1:
                    addPlaylist(&playlistHead, &playlistCount); // Call addPlaylist().
                    break;
                case 2:
                    addSongToPlaylist(&playlistHead, &playlistCount); // Call addSongToPlaylist().
                    break;
                case 3:
                    removeSongFromPlaylist(&playlistHead, &playlistCount); // Call removeSongFromPlaylist().
                    break;
                case 4:
                    viewAPlaylist(playlistHead, playlistCount); // Call viewAPlaylist().
                    break;
                case 5:
                    viewAllData(playlistHead, playlistCount); // Call viewAllData().
                    break;
                case 6:
                    saveData(playlistHead); // Call saveData().
                    freeHeap(&playlistHead); // Call freeHeap().
                    return 0; // Exit program.
                    break;
                default:
                    break;
            }
        } else invalidInputErr();
    } return 0;
}

/* void saveData(arg1)
Function used to save data.
Accepts a reference to a struct as argument.
*/
void saveData(playlist *playlistHead){
    int currentSong = 0; // Declare and initialize currentSong.

    if(playlistHead == NULL){ // Executes if playlistHead is NULL.
        printf("\n[!] There are no playlists to be written! [!]\n\n");
        printf("---------------------------------------\n\n");
        return;
    }

    FILE *myFile = fopen("Playlist.txt","w"); // Open file for writing.
    while(playlistHead != NULL){ // Iterate through all instances of playlist playlistHead.
        // Write playlist details to file. Writes a newline in the end if there is still a next playlist and if there are songs in the playlist to be written.
        if(playlistHead->nextPlaylist_ == NULL && playlistHead->songCount == 0) fprintf(myFile,"%s_(µ) %d", playlistHead->playlistName, playlistHead->songCount);
        else fprintf(myFile,"%s_(µ) %d\n", playlistHead->playlistName, playlistHead->songCount);

        song *tempSongHead_ = playlistHead->songHead; // Declare and initialize a tempSongHead.
        currentSong = 0; // Reinitialize the currentSong to 0.
        while(tempSongHead_ != NULL){ // Iterate through all instances of tempSongHead.
            // Write current song details to file. Writes a newline in the end if there is still a next song and if there is still a next playlist.
            if(playlistHead->songCount-currentSong == 1 && playlistHead->nextPlaylist_ == NULL) fprintf(myFile,"%s\n%s\n%s", tempSongHead_->songTitle, tempSongHead_->songArtist, tempSongHead_->songAlbum);
            else fprintf(myFile,"%s\n%s\n%s\n", tempSongHead_->songTitle, tempSongHead_->songArtist, tempSongHead_->songAlbum);
            currentSong++; // Increment currentSong.
            tempSongHead_ = tempSongHead_->nextSong_; // Assign tempSongHead_->nextSong_ as new tempSongHead_.
        } playlistHead = playlistHead->nextPlaylist_; // Assign playlistHead->nextPlaylist_ as new playlistHead.
    }
        
    printf("[✓] Successfully saved data [✓]\n"); // Print a success message
    fclose(myFile); // Close file.
}

/* void loadData(arg1, arg2)
Function used to load data.
Accepts a reference to a reference of a struct and a reference to an integer as argument.
*/
void loadData(playlist **playlistHead, int *playlistCount){
    // Declare and initialize variables.
    int songCount = 0, currentSong = 0;
    char buffer[BUFFER_SIZE];

    FILE *myFile=fopen("Playlist.txt","r"); // Open file for reading.

    if(myFile == NULL){ // Executes if "Playlist.txt" cannot be opened or does not exist.
        printf("[!] Playlist DB does not exist! [!]\n\n");
        return;
    } while(fscanf(myFile, "%[^_(µ)]", buffer) > 0){ // Executes while there is still a playlistHead->pLaylistName that can be read from myFile.
        currentSong = 0; // Reinitialize currentSong to 0.

        playlist *newPlaylist_ = (playlist *) malloc(sizeof(playlist)); // Create a new playlist node.

        // Initialize the new playlist node.
        newPlaylist_->songHead = NULL;
        newPlaylist_->nextPlaylist_ = NULL;

        // Allocate memory for and assign buffer as newPlaylist->playlistName.
        newPlaylist_->playlistName = (char *) malloc(sizeof(char)*(strlen(buffer)+1));
        strcpy(newPlaylist_->playlistName, buffer);

        insertNewPlaylistNode(playlistHead, newPlaylist_); // Call insertNewPlaylistNode();
        
        sscanf(fgets(buffer, BUFFER_SIZE, myFile), "_(µ) %d", &songCount); // Read the remaining characters of the stream from the delimiter and assign the integer read as songCount.
        
        newPlaylist_->songCount = songCount; // Assign songCount as newPlaylist_->songCount.
        (*playlistCount)++; // Increment *playlistCount.

        while(currentSong < songCount){ // Executes while there are still songs that are expected to be read.
            // Read a line from myFile and assign it to buffer. Immediately replace the last character of buffer to '\0' since fgets reads '\n' as well.
            fgets(buffer, BUFFER_SIZE, myFile);
            buffer[strlen(buffer) - 1] = '\0';
            
            // Create a new song node and initialize newSong_->nextSong_ to NULL.
            song *newSong_ = (song *) malloc(sizeof(song));
            newSong_->nextSong_ = NULL;

            // Dynamically allocate memory for songTitle and copy buffer's contents to it.
            newSong_->songTitle = (char *) malloc(sizeof(char)*(strlen(buffer)+1));
            strcpy(newSong_->songTitle, buffer);
            
            insertNewSongNode(&newPlaylist_, newSong_); // Call insertNewSongNode().

            fgets(buffer, BUFFER_SIZE, myFile);
            buffer[strlen(buffer) - 1] = '\0';

            // Dynamically allocate memory for artistName and copy buffer's contents to it.
            newSong_->songArtist = (char *) malloc(sizeof(char)*(strlen(buffer)+1));
            strcpy(newSong_->songArtist, buffer);
            
            fgets(buffer, BUFFER_SIZE, myFile);
            if(buffer[strlen(buffer) - 1] == '\n') buffer[strlen(buffer) - 1] = '\0';

            // Dynamically allocate memory for songAlbum and copy buffer's contents to it.
            newSong_->songAlbum = (char *) malloc(sizeof(char)*(strlen(buffer)+1));
            strcpy(newSong_->songAlbum, buffer);

            newSong_ = newSong_->nextSong_; // Assign newSong_ as newSong_->nextSong_.
            currentSong++; // Increment currentSong.
        } 
    } printf("[✓] Successfully loaded data [✓]\n\n");
    fclose(myFile);
}


/* int insertNewPlaylistNode(arg1, arg2)
Function used to insert a new playlist node to an existing linked list.
Accepts a reference to a reference of a struct and a reference to another struct as argument.
*/
int insertNewPlaylistNode(playlist **playlistHead, playlist *newPlaylist_){
    playlist *scanPlaylist_ = (*playlistHead); // Create a scanner playlist node.
    while(scanPlaylist_ != NULL){ // Executes until end of scanPlaylist_.
        if(strcmp(scanPlaylist_->playlistName, newPlaylist_->playlistName) == 0){ // Catch if newPlaylist_->playlistName has an equal value in the system.
            printf("\n[!] Playlist name already exists! [!]\n");
            printf("---------------------------------------\n\n");
            return 1; // Exit the function and return 1.
        } scanPlaylist_ = scanPlaylist_->nextPlaylist_; // Assign scanPlaylist->nextPlaylist_ as new scanPlaylist_.
    }

    // Initialize newPlaylist_.
    newPlaylist_->songCount = 0;
    newPlaylist_->songHead = NULL;
    newPlaylist_->nextPlaylist_ = NULL;

    // Generalized algorithm for insertion to head, middle, or tail. 
    if((*playlistHead) == NULL || ((*playlistHead) != NULL && strcmp(newPlaylist_->playlistName, (*playlistHead)->playlistName) < 0)) { 
        newPlaylist_->nextPlaylist_ = (*playlistHead); // Assign *playlistHead to newPlaylist_->nextPlaylist_.
        (*playlistHead) = newPlaylist_;  // Put playlist pointer at the head if (*playlistHead)->name is empty or newPlaylist_->name > (*playlistHead)->name.
    } else{
        playlist *tempPlaylist_ = (*playlistHead); // Create a new playlist node for temporary storage.
        while(tempPlaylist_->nextPlaylist_ != NULL && strcmp(tempPlaylist_->nextPlaylist_->playlistName, newPlaylist_->playlistName) < 0){
            tempPlaylist_ = tempPlaylist_->nextPlaylist_; // Insertion to middle
        } newPlaylist_->nextPlaylist_ = tempPlaylist_->nextPlaylist_; // Insertion to tail.
        tempPlaylist_->nextPlaylist_ = newPlaylist_; // Assign nextPlaylist_ as new playlistHead.
    } return 0;
}

/* void insertNewSongNode(arg1, arg2)
Function used to insert a new song node in a linked list member of an existing linked list.
Accepts a reference to a reference of a struct and a reference to another struct as argument.
*/
void insertNewSongNode(playlist **scanPlaylist, song *newSong_){
    // Generalized algorithm for insertion to head, middle, or tail. 
    if((*scanPlaylist)->songHead == NULL || ((*scanPlaylist)->songHead != NULL && strcmp(newSong_->songTitle, (*scanPlaylist)->songHead->songTitle) < 0)) { 
        newSong_->nextSong_ = (*scanPlaylist)->songHead;
        (*scanPlaylist)->songHead = newSong_; 
    } else{  
        song *tempSong_ = (*scanPlaylist)->songHead;
        while(tempSong_->nextSong_ != NULL && strcmp(tempSong_->nextSong_->songTitle, newSong_->songTitle) < 0){
            tempSong_ = tempSong_->nextSong_;
        } newSong_->nextSong_ = tempSong_->nextSong_;
        tempSong_->nextSong_ = newSong_;
    }
}

/* void fetchSongs(arg1)
Function used to print all songs—and all their details—in a playlist.
Accepts a reference to a struct as argument.
*/
void fetchSongs(song *songHead){
    while(songHead != NULL){ // Executes until end of songHead.
        // Print song contents.
        if(songHead->nextSong_ == NULL){
            printf(" ╚═╦══[SONG TITLE]: %s\n", songHead->songTitle);
            printf("   ╠══[SONG ARTIST]: %s\n", songHead->songArtist);
            printf("   ╚══[SONG ALBUM]: %s\n\n", songHead->songAlbum);
            return;
        } else{
            printf(" ╠═╦══[SONG TITLE]: %s\n", songHead->songTitle);
            printf(" ║ ╠══[SONG ARTIST]: %s\n", songHead->songArtist);
            printf(" ║ ╚══[SONG ALBUM]: %s\n", songHead->songAlbum);
            printf(" ║\n");
        } songHead = songHead->nextSong_; // Assign songPlaylist_ as new songHead.
    }
}

/* void availableSongsForDeletion(arg1, arg2, arg3)
Function used to print the available songs of a playlist for deletion.
Accepts a reference to a struct, an integer, and a reference to another struct as argument.
*/
void availableSongsForDeletion(playlist *scanPlaylist, int songCount, song *songHead){
    printf("\n[≡] The list of available songs in %s are:\n", scanPlaylist->playlistName);
    printf(" ║ \n");
    for(int i = 0; songHead != NULL || i < songCount; i++){ // Iterate until songHead is NULL or i == songCount.
        if(songCount-i == 1){
            printf(" ╚══[%d] %s\n\n", i, songHead->songTitle);
        } else printf(" ╠══[%d] %s\n", i, songHead->songTitle);
        songHead = songHead->nextSong_;
    }
}

/* void printPlaylists(arg1)
Function used to print available playlists.
Accepts a reference to a struct as argument.
*/
void printPlaylists(playlist *playlistHead){
    int counter = 0; // Declare and initialize a counter.

    printf("\n[≡] The list of available playlists are:\n");
    printf(" ║ \n");
    while(playlistHead != NULL){ // Executes until end of playlistHead.
        // Print playlists.
        if(playlistHead->nextPlaylist_ == NULL){
            printf(" ╚══[%d] %s\n\n", counter, playlistHead->playlistName);
            return;
        } printf(" ╠══[%d] %s\n", counter, playlistHead->playlistName);

        counter++; // Increment counter.
        playlistHead = playlistHead->nextPlaylist_; // Assign nextPlaylist_ as new playlistHead.
    }   
}

/* void printPlaylists(arg1, arg2)
Function used to print a playlist and all their songs together with their details.
Accepts a reference to a struct and an integer as argument.
*/
void printPlaylistContents(playlist *playlistHead, int choice){
    int counter = 0;

    // Assigns playlistHead to the playlist of choice of user.
    while(playlistHead != NULL){ 
        if(counter == choice) break;
        counter++;
        playlistHead = playlistHead->nextPlaylist_;
    } if(playlistHead->songCount == 0){ // Prints if there are no songs in the playlist. Exits the function immediately.
        printf("[≡] PLAYLIST: %s\n", playlistHead->playlistName);
        printf(" ║ \n");
        printf(" ╚[!] There are no songs in the playlist yet! [!]\n\n");
        return;
    }

    // Print playlist name, the song count of the playlist, and its contents.
    printf("[≡] PLAYLIST: %s\n", playlistHead->playlistName);
    printf(" ║ \n");
    printf(" ╠══[SONG COUNT]: %d\n", playlistHead->songCount);
    printf(" ║ \n");
    fetchSongs(playlistHead->songHead); // Call fetchSongs();
}

/* void addPlaylist(arg1, arg2)
Function used to add a new playlist.
Accepts a reference to a reference of a struct and a reference to an integer as argument.
*/
void addPlaylist(playlist **playlistHead, int *playlistCount){
    int flag = 0;
    char buffer[BUFFER_SIZE];

    if(*playlistCount == 10){ // Check if system is full.
        printf("\n[!] System is already full! Returning to main menu. [!]\n\n");
        return;
    } playlist *newPlaylist_ = (playlist *) malloc(sizeof(playlist)); // Create a new playlist node.

    while(1){
        printf(" ╔════════════════════════════════════════════════════════════════════════|\n");
        printf("[≡] Enter playlist name: ");
        if(!flag) while (getchar() != '\n'); // Flush stdin.
        fgets(buffer, BUFFER_SIZE, stdin);
        buffer[strlen(buffer) - 1] = '\0'; 
        printf(" ╚════════════════════════════════════════════════════════════════════════|\n");

        if(strlen(buffer) == 0) flag = blankInputErr("Playlist name"); // Executes if buffer is empty.
        else break;
    }

    // Dynamically allocate memory for newPlaylist_->name and copy buffer to newPlaylist_->name.
    newPlaylist_->playlistName = (char *) malloc(sizeof(char)*(strlen(buffer)+1)); 
    strcpy(newPlaylist_->playlistName, buffer);
    
    if(insertNewPlaylistNode(playlistHead, newPlaylist_) == 1){
        free(newPlaylist_->playlistName); // Free the allocated memory for newPlaylist_->playlistName.
        free(newPlaylist_); // Free the allocated memory for newPlaylist_.
        return; // Exits function early.
    } (*playlistCount)++; // Increment playlist count.
    printf("\n[✓] Playlist successfully added [✓]\n\n");
    printf("---------------------------------------\n\n");
}

/* void addPlaylist(arg1, arg2)
Function used to add a new playlist song to an existing playlist.
Accepts a reference to a reference of a struct and a reference to an integer as argument.
*/
void addSongToPlaylist(playlist **playlistHead, int *playlistCount){
    int scanfRtn = 0, counter = 0, choice = 0, flag = 0;
    char buffer[BUFFER_SIZE];

    if((*playlistHead) == NULL){
        noPlaylistsErr(); // Executes if playlistHead is empty.
        return;
    } song *newSong_ = (song *) malloc(sizeof(song)); // Creates a new song node.
    while(1){
        printPlaylists(*playlistHead); // Call printPlaylists();
        printf(" ╔══════════════════|\n");
        printf("[≡] Enter choice: "); scanfRtn = scanf("%d", &choice);
        printf(" ╚══════════════════|\n\n");

        if(scanfRtn == 0) invalidInputErr();
        else if(choice >= 0 && choice != (*playlistCount)){
            playlist *scanPlaylist = *playlistHead; // Create a scanner playlist node.
            while(scanPlaylist != NULL || counter < choice){ // Assigns scanPlaylist to the playlist of choice of user. 
                if(counter == choice) break;
                counter++;
                scanPlaylist = scanPlaylist->nextPlaylist_;
            }

            if(scanPlaylist->songCount < 10){ // Only executes if the playlist is not full.
                while(1){ // Song title loop
                    printf("Enter song's title: ");
                    if(!flag) while (getchar() != '\n'); // Flush stdin.
                    fgets(buffer, BUFFER_SIZE, stdin);
                    buffer[strlen(buffer) - 1] = '\0';
                    if(strlen(buffer) == 0) flag = blankInputErr("Song title"); // Executes if buffer is empty.
                    else break;
                }

                newSong_->songTitle = (char *) malloc(sizeof(char)*(strlen(buffer)+1)); 
                strcpy(newSong_->songTitle, buffer);
                insertNewSongNode(&scanPlaylist, newSong_);
                newSong_->nextSong_ = NULL;

                while(1){ // Artist name loop
                    printf("Enter artist name: ");
                    if(!flag) while (getchar() != '\n');
                    fgets(buffer, BUFFER_SIZE, stdin);
                    buffer[strlen(buffer) - 1] = '\0';
                    if(strlen(buffer) == 0) flag = blankInputErr("Artist name");
                    else break;
                }

                // Dynamically allocate memory for artist and copy buffer's contents to it.
                newSong_->songArtist = (char *) malloc(sizeof(char)*(strlen(buffer)+1)); 
                strcpy(newSong_->songArtist, buffer);

                while(1){ // Song album loop
                    printf("Enter song's album title: ");
                    if(!flag) while (getchar() != '\n');
                    fgets(buffer, BUFFER_SIZE, stdin);
                    buffer[strlen(buffer) - 1] = '\0';
                    if(strlen(buffer) == 0) flag = blankInputErr("Song's album title");
                    else break;
                }

                // Dynamically allocate memory for album and copy buffer's contents to it.
                newSong_->songAlbum = (char *) malloc(sizeof(char)*(strlen(buffer)+1)); 
                strcpy(newSong_->songAlbum, buffer);

                printf("\n[✓] Song successfully added [✓]\n");
                printf("---------------------------------------\n\n");
                (scanPlaylist->songCount)++; // Increment the songCount
                return;
            } else{ // Executes if playlist is full.
                printf("\n[!] PLAYLIST IS ALREADY FULL. Returning to main menu. [!]\n\n");
                while (getchar() != '\n'); // Flush stdin.
                return;
            }
        } else invalidInputErr();
    }
}

/* void removeSongFromPlaylist(arg1, arg2)
Function used to add remove a song from an existing playlist.
Accepts a reference to a reference of a struct and a reference to an integer as argument.
*/
void removeSongFromPlaylist(playlist **playlistHead, int *playlistCount){
    int scanfRtn = 0, choice = 0, counter = 0, countPlaylist = 0, countSong = 0;

    if(*playlistHead == NULL){
        noPlaylistsErr();
        return;
    } while(1){
        printPlaylists(*playlistHead);
        printf(" ╔══════════════════|\n");
        printf("[≡] Enter choice: "); scanfRtn = scanf("%d", &choice);
        printf(" ╚══════════════════|\n\n");

        if(scanfRtn == 0) invalidInputErr();
        else if(choice >= 0 && choice < *playlistCount){
            playlist *scanPlaylist = *playlistHead;
            while(scanPlaylist != NULL || countPlaylist < choice){
                if(countPlaylist == choice) break;
                countPlaylist++;
                scanPlaylist = scanPlaylist->nextPlaylist_;
            }
            
            if(scanPlaylist->songCount == 0){
                printf("[!] There are no songs in the playlists yet! [!]\n\n"); // Print error message when there are no playlists.
                printf("---------------------------------------\n\n");
                return;
            } availableSongsForDeletion(scanPlaylist, scanPlaylist->songCount, scanPlaylist->songHead); // Call availableSongsForDeletion().
            printf(" ╔══════════════════|\n");
            printf("[≡] Enter choice: "); scanfRtn = scanf("%d", &choice);
            printf(" ╚══════════════════|\n\n");

            if(scanfRtn == 0) invalidInputErr;
            else if(choice >= 0 && choice < scanPlaylist->songCount){
                counter = 0; // Reinitialize counter as 0.
                song *deleteSong = scanPlaylist->songHead; // Create new song node for deletion.
                while(deleteSong != NULL){
                    if(counter == choice){ // Executes if the song is found.
                        if(deleteSong == scanPlaylist->songHead){ // Delete at head.
                            scanPlaylist->songHead = scanPlaylist->songHead->nextSong_; // Assign scanPlaylist->songHead->nextSong_ as new scanPlaylist->songHead.
                            scanPlaylist->songCount--; // Decrement scanPlaylist->songCount.

                            // Free song details before freeing deleteSong.
                            free(deleteSong->songTitle);
                            free(deleteSong->songArtist);
                            free(deleteSong->songAlbum);
                            free(deleteSong);
                            break;
                        } else{ // Delete at middle or tail.
                            song *tempSong = scanPlaylist->songHead; // Create new song node for temporary storage.
                            while(tempSong->nextSong_ != deleteSong){ // Executes while tempSong->nextSong_ != deleteSong.
                                tempSong = tempSong->nextSong_; // Assign tempSong->nextSong_ as new tempSong.
                            } tempSong->nextSong_ = deleteSong->nextSong_; // Assign deleteSong->nextSong_ as new tempSong->nextSong_.
                            scanPlaylist->songCount--; // Decrement scanPlaylist->songCount.
                            
                            // Free song details before freeing deleteSong.
                            free(deleteSong->songArtist);
                            free(deleteSong->songAlbum);
                            free(deleteSong);
                            break;
                        }
                    } counter++; // Increment counter.
                    deleteSong = deleteSong->nextSong_; // Assign deleteSong->nextSong_ as new deleteSong.
                } printf("\n[✓] Song successfully deleted [✓]\n\n");
                printf("---------------------------------------\n\n");
                return;
            }
        } else invalidInputErr();
    }
}

/* void viewAPlaylist(arg1, arg2)
Function used to view a playlist.
Accepts a reference to a struct and an integer as argument.
*/
void viewAPlaylist(playlist *playlistHead, int playlistCount){
    int scanfRtn = 0, choice = 0;

    if(playlistHead == NULL){
        noPlaylistsErr();
        return;
    } while(1){
        printPlaylists(playlistHead);
        printf(" ╔══════════════════|\n");
        printf("[≡] Enter choice: "); scanfRtn = scanf("%d", &choice);
        printf(" ╚══════════════════|\n\n");

        if(scanfRtn == 0) invalidInputErr();
        else if(choice >= 0 && choice < playlistCount){
            printPlaylistContents(playlistHead, choice); // Call printPlaylistContents();
            printf("---------------------------------------\n\n");
            return;
        } else invalidInputErr();
    }
}

/* void viewAPlaylist(arg1, arg2)
Function used to view all data.
Accepts a reference to a struct and an integer as argument.
*/
void viewAllData(playlist *playlistHead, int playlistCount){
    if(playlistHead == NULL){
        noPlaylistsErr();
        return;
    }
    for(int i = 0; i < playlistCount; i++){ // Iterates until i == playlistCount.
        printPlaylistContents(playlistHead, i);
        if(!(playlistCount-i == 1)) printf("[+]═══════════════════════════════════════════════|\n\n");
    } printf("---------------------------------------\n\n");
}

/* void freeHeap(arg1)
Function used to free memory in heap.
Accepts a reference to a reference of a struct as argument.
*/
void freeHeap(playlist **playlistHead){
    while(*playlistHead != NULL){ // Executes until end of *playlisthead.
        playlist *tempPlaylist_ = (*playlistHead); // Create new playlist node for temporary storage.
        while((*playlistHead)->songHead != NULL){ // Executes until end of (*playlisthead)->songHead.
            song *tempSong = (*playlistHead)->songHead; // Create new song node for temporary storage.
            (*playlistHead)->songHead = (*playlistHead)->songHead->nextSong_; // Assign (*playlistHead)->songHead->nextSong_ as new (*playlistHead)->songHead.

            // Free song details before freeing tempSong.
            free(tempSong->songTitle);
            free(tempSong->songArtist);
            free(tempSong->songAlbum);
            free(tempSong);
        } (*playlistHead) = (*playlistHead)->nextPlaylist_; // Assign (*playlistHead)->nextPlaylist_ as new (*playlistHead).

        // Free playlist name before freeing tempPlaylist_.
        free(tempPlaylist_->playlistName);
        free(tempPlaylist_);
    }
}

/* void noPlaylistErr()
Function used to print an error message when there are no playlists.
*/
void noPlaylistsErr(){
    printf("[!] There are no playlists yet! [!]\n\n"); // Print error message when there are no playlists.
    printf("---------------------------------------\n\n");
    return;
}

/* void invalidInputErr()
Function used to print an error message when user entered invalid input.
*/
void invalidInputErr(){
    printf("\n[!] INVALID INPUT! Try Again. [!]\n\n"); // Print error message when user entered invalid input.
    while (getchar() != '\n');
}

/* void invalidInputErr()
Function used to print an error message user entered blank input.
*/
int blankInputErr(char *input){
    printf("\n[!] %s cannot be blank! [!]\n", input); // Print error message when user entered blank input.
    printf("---------------------------------------\n\n");
    return 1;
}