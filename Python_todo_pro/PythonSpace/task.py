from fastapi import FastAPI
import pymysql

app = FastAPI()

def connect():
    conn = pymysql.connect(
        host='127.0.0.1',
        user='root',
        passwd='qwer1234',
        db='todolist',
        charset='utf8'
    )
    return conn

@app.get("/select")
async def select():
    conn = connect()
    curs = conn.cursor()

    sql = "select seq, title, image, date from task"
    curs.execute(sql)
    rows = curs.fetchall()
    conn.close()
    print(rows)

    result = [{'seq' : row[0], 'title' : row[1],'image' : row[2],'date' : row[3]} for row in rows]
    return {'results' : result}

@app.get("/insert")
async def insert(seq: str=None, title: str=None, image: str=None, date: str=None):
    conn = connect()
    curs = conn.cursor()
    
    try:
        sql = "insert into task(title, image, date) values (%s,%s,%s)"
        curs.execute(sql,(title, image, date))
        conn.commit()
        conn.close()
        return {'results': 'OK'}

    except Exception as e:
        conn.close()
        print("Error :", e)
        return {'result': 'Error'}

@app.get("/remove")
async def remove(seq: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = "DELETE FROM task WHERE seq = %s"
        curs.execute(sql, (seq))
        conn.commit()
        conn.close
        return {'results': 'OK'}
    
    except Exception as e:
        conn.close()
        print('Error :', e)
        return {'result': 'Error'}
    
@app.get("/update")
async def update(seq: str=None, title: str=None, image: str=None, date: str=None):
    conn = connect()
    curs = conn.cursor()

    try:
        sql = """
        UPDATE task
        SET title = %s,
        image = %s,
        date = %s
        WHERE seq = %s
        """
        curs.execute(sql, (title, image, date, seq))
        conn.commit()
        conn.close
        return {'results': 'OK'} 
    
    except Exception as e:
        conn.close()
        print('Error :', e)
        return {'result': 'Error'}    

if __name__=="__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)