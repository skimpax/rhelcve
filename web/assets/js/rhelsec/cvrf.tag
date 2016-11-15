<cvrf>
    <h3 class="text-primary">CVRF for Triage</h3>

    <div>
        <h4>Request Criteria  <small>in RHEL security DB</small></h4>
        <form class="form-inline">
            <label for="basic-url">Since Date:</label>
            <div class="input-group date" data-provide="datepicker">
                <input type="text" class="form-control">
                <div class="input-group-addon">
                    <span class="glyphicon glyphicon-th"></span>
                </div>
            </div>
<!--             <div class="form-group">
                <label for="exampleInputName2">Criticity</label>
                <input type="text" class="form-control" id="exampleInputName2" placeholder="Jane Doe">
            </div> -->
            <label for="exampleInputName2">Severity</label>
            <div class="btn-group">
                <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                Level <span class="caret"></span>
                </button>
                <ul class="dropdown-menu">
                    <li><a href="#">Critical</a></li>
                    <li><a href="#">Important</a></li>
                    <li><a href="#">Moderate</a></li>
                    <li><a href="#">Low</a></li>
                </ul>
            </div>
            <button type="submit" class="btn btn-success">Apply</button>
        </form>
    </div>

    <hr>

    <div if={ isLoading } class='loader center-block'>
        <!-- <img src='puff.svg' /> -->
        <i class="fa fa-spinner fa-spin" style="font-size:24px"></i>
    </div>

    <div class="alert alert-warning" if={ error }>{ error }</div>

    <div if={ isLoading == false } >
        <div if={ items.length }>

            <table id="cvrftable" class="table table-striped table-bordered" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <th>Index</th>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Info</th>
                    </tr>
                </thead>
                <tfoot>
                    <tr>
                        <th>Index</th>
                        <th>Released On</th>
                        <th>RHSA</th>
                        <th>Severity</th>
                        <th>Released Pkg</th>
                        <th>Info</th>
                    </tr>
                </tfoot>
                <tbody>
                    <tr each="{ value, i in items }">
                        <td>#{ i }</td>
                        <td>{ value.released_on }</td>
                        <td>{ value.RHSA }</td>
                        <td>{ value.severity }</td>
                        <td>{ value.released_packages }</td>
                        <td><a href="{ convert2htmllink(value.resource_url) }">link</a></td>
                    </tr>
                </tbody>
            </table>

        </div>
        <div if={ items.length == 0 }>
            <div class="alert alert-info">No CVRF emitted.</div>
        </div>
    </div>


    <script type="text/javascript">

        this.items = [];
        this.isLoading = true;
        this.error = null;

        var self = this

        convert2htmllink = function(jsonlink) {

            // https://access.redhat.com/documentation/en/red-hat-security-data-api/version-0.1/red-hat-security-data-api/
            // remove '.json' in URL to get link hat will return data in plain HTML 
            return jsonlink.replace(/\.json$/, "");
            // return jsonlink;
        }

        doApiRequest = function() {

            $.getJSON("/api/cvrf", function(results) {
                console.log(results);
                self.items = results.data;
            })
            .done(function() {
            // alert( "second success" );
            })
            .fail(function() {
                // alert( "error" );
                self.error = "Failed to retrieve data from server!";
            })
            .always(function() {
                // alert( "finished" );
                self.isLoading = false;
                self.update()
                $('#cvrftable').DataTable();
            });
        }

        self.on('mount', function(){

            $('.datepicker').datepicker();

            doApiRequest();
        })

    </script>

</cvrf>
