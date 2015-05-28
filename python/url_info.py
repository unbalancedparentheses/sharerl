from newspaper import Article

def info(burl):
    url = burl.decode('ascii')
    article = Article(url)
    article.download()
    article.parse()

    title = article.title

    authors = []
    for author in article.authors:
        authors.append(bytes(author, 'utf-8'))

    text = article.text

    return (bytes(title, 'utf-8'), authors, bytes(text, 'utf-8'))
