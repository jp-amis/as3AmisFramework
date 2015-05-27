package co.amis {
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLStatement;
	import flash.filesystem.File;
	import flash.data.SQLResult;

	public class Database {
		
		private static var _instance:Database;
		private var sqlConnectionSync:SQLConnection;
		
		public function Database() {
			if(_instance){
				throw new Error("Singleton... use getInstance()");
			} 
			_instance = this;
			
			//initDB();
		}		
		public static function getInstance():Database {
			if(!_instance){
				new Database();
			} 
			return _instance;
		}
		
		/*private function initDB():void {
			var file:File = File.applicationStorageDirectory.resolvePath("pizzas2.db");
			sqlConnectionSync = new SQLConnection();//create a connection object			
			if(file.exists){
				sqlConnectionSync.open(file, SQLMode.CREATE); //create the database
			}else{
				sqlConnectionSync.open(file, SQLMode.CREATE); //create the database				
				var createDb:SQLStatement = new SQLStatement();				
				//create a table
				createDb.text = "CREATE TABLE round (id INTEGER  PRIMARY KEY AUTOINCREMENT DEFAULT NULL,created_at TEXT DEFAULT CURRENT_TIMESTAMP,updated_at TEXT DEFAULT CURRENT_TIMESTAMP,active INTEGER DEFAULT 0,slices INTEGER DEFAULT 0)";
				createDb.sqlConnection = sqlConnectionSync; //set the connection that will be used
				createDb.execute();	
			}
		}
		
		private function writeData():void {
//			var insert:SQLStatement = new SQLStatement(); //create the insert statement
//			insert.sqlConnection = sqlConnectionSync; //set the connection
//			insert.text = "INSERT INTO messages (subject, message) VALUES (?, ?)";
//			insert.parameters[0] = subject.text;
//			insert.parameters[1] = message.text;
//			insert.execute();
//			Alert.show("The data was saved into the table!");
		}
		
		private function readData():void {
//			var read:SQLStatement = new SQLStatement(); //create the read statemen
//			read.sqlConnection = sqlConnectionSync; //set the connection
//			read.text = "SELECT id, subject, message FROM messages ORDER BY id";
//			read.execute();
//			var result:SQLResult = read.getResult(); //retrieve the result of the query
//			myDatagrid.dataProvider = result.data; //display the array of objects into the data grid
		}
		
		public function getRoundCount():int {
			var read:SQLStatement = new SQLStatement(); //create the read statemen
			read.sqlConnection = sqlConnectionSync; //set the connection
			read.text = "SELECT count(*) as total FROM round";
			read.execute();		
			var result:SQLResult = read.getResult(); //retrieve the result of the query		
			
			if(result.data !== null)
				return result.data[0].total;
			else return 0;
		}
		
		public function getLifetime():void {
			
		}
		
		public function getLastRound():int {
			var round:int = 0;
			var read:SQLStatement = new SQLStatement(); //create the read statemen
			read.sqlConnection = sqlConnectionSync; //set the connection
			read.text = "SELECT id, slices FROM round ORDER BY id DESC LIMIT 1";
			read.execute();		
			var result:SQLResult = read.getResult();			
			round = result.data[0].slices				
			return round;
		}
		
		public function saveRound(slices:int):void {
			var sqlStatement:SQLStatement = this.SQLStatementFabric();
			sqlStatement.text = "INSERT INTO round (active, slices) VALUES (1, "+slices+");";
			sqlStatement.execute();
		}
		
		private function SQLStatementFabric():SQLStatement {
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = sqlConnectionSync;
			
			return statement;
		}*/
	}
	
}