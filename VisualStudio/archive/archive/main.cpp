#include "Chapter.h"
#include "archive.h"
#include "artPiece.h"
#include "Book.h"
#include "Album.h"
#include "Song.h"

int main() {

	Book myFirstBook("Me", "MyFirstBook", 25, 3);
	Archive bookArchive;
	Archive musicArchive;

	Album myFirstAlbum("Me", "MyFirstAlbum", 2);

	musicArchive.addArtpiece(myFirstAlbum);

	musicArchive.printInfo("Me");

	bookArchive.addArtpiece(myFirstBook);

	bookArchive.printTitle("Me");
	bookArchive.printCreator("MyFirstBook");
	bookArchive.printAmount("Me");
	bookArchive.printInfo("MyFirstBook");

	Chapter ChapterOne("Boom BabY", 3);
	Chapter ChapterTwo;

	Song SongNrOne;

	myFirstBook.addChapter(ChapterOne);
	myFirstBook.addChapter(ChapterTwo);
	bookArchive.updateArchive(myFirstBook);

	bookArchive.printAmount("Me");


	return 0;

}