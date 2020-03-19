import {LightningElement, api, wire, track} from 'lwc';
import getAllTask from '@salesforce/apex/TaskManagerController.getAllTask';
import getChangeCheckbox from '@salesforce/apex/TaskManagerController.getChangeCheckbox';

export default class Todolist extends LightningElement {
    @track mapData = [];
    @track error;

    @wire(getAllTask)
    wiredResult(result) {
        if (result.data) {
            let resultData = result.data;
            for (let key in resultData) {
                this.mapData.push({value: resultData[key], key: key});
            }
        }
    }

    handleClick(event) {
        let recordId = event.target.value;
        getChangeCheckbox({recordId: recordId})
            .then(result => {
                this.mapData = [];
                let resultData = result;
                for (let key in resultData) {
                    this.mapData.push({value: resultData[key], key: key});
                }
            })
            .catch(error => {
                this.error = error;
            });
    }

}
